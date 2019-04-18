
Apache Pig is good for scripting data transformations, and it allows logic implemented in Java to be integrated as UDFs (user-defined functions). Here is a short story of investigating and fixing an OOM (out of memory) issue, where such a UDF was used.

### The UDF

The implementation of this UDF is extremely simple. It basically serves lookup queries using an in-memory [HashMap](https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html), which is initialized with the key-value pairs from a text file at construction time.

```
public class Lookup extends EvalFunc<String> {

    private Map<String, String> map;
    private final String uri;
    private final String filename;
    private final String fieldName;
    private final String defaultValue;

    public Lookup(String uri, String filename, String fieldName, String defaultValue) throws IOException {
        this.uri = uri;
        this.filename = filename;
        this.fieldName = fieldName;
        this.defaultValue = defaultValue;
    }

    @Override
    public String exec(Tuple input) throws IOException {
        if (input == null || input.get(0) == null || input.size() > 1) {
            return null;
        }
        if (map == null) {
            map = // ... initialize the map using the filename
        }

        String key = DataType.toString(input.get(0));
        String val = map.get(key);
        return val == null ? defaultValue : val;
    }

    /**
     * This makes the file at the URI `uri` accessible locally (data nodes where the UDF is running) under the name `filename`
     */
    @Override
    public List<String> getCacheFiles() {
        List<String> files = new ArrayList<>(1);
        files.add(uri + "#" + filename);
        return files;
    }

    @Override
    public Schema outputSchema(Schema input) {
        return new Schema(new Schema.FieldSchema(fieldName, DataType.CHARARRAY));
    }
}
```

The UDF can be defined and used in Pig scripts like this:

```
DEFINE lookupUserName io.github.ouyi.Lookup('$fileUriOnHdfs', '$filename', 'userName', 'default_value');

...

FOREACH inputRecords
GENERATE
    userId,
    lookupUserName(userId) AS userName,
...
```

<!--
It is just a lookup function similar to the one described here.
-->

### The issue

The Pig script with the UDF worked fine for a long time until one day it started to fail. The error log message looks like this:

```
2018-01-20 02:24:53.034 [info]   2812581 [PigTezLauncher-0] INFO  org.apache.pig.backend.hadoop.executionengine.tez.TezJob  - DAG Status: status=FAILED, progress=TotalTasks: 116 Succeeded: 104 Running: 0 Failed: 1 Killed: 9 FailedTaskAttempts: 4 KilledTaskAttempts: 13, diagnostics=Vertex failed, vertexName=scope-1290, vertexId=vertex_1516355082351_0460_1_01, diagnostics=[Task failed, taskId=task_1516355082351_0460_1_01_000040, diagnostics=[TaskAttempt 1 failed, info=[Container container_1516355082351_0460_01_000052 timed out], TaskAttempt 2 failed, info=[Error: Encountered an Error while executing task: attempt_1516355082351_0460_1_01_000040_2:java.lang.OutOfMemoryError: GC overhead limit exceeded
2018-01-20 02:24:53.034 [info]   	at java.lang.String.substring(String.java:1969)
2018-01-20 02:24:53.034 [info]   	at java.lang.String.split(String.java:2353)
2018-01-20 02:24:53.034 [info]   	at java.lang.String.split(String.java:2422)
2018-01-20 02:24:53.034 [info]   	at
...

2018-01-20 02:24:53.044 [info]   Failed vertices:
2018-01-20 02:24:53.044 [info]   VertexId  State Parallelism TotalTasks   InputRecords   ReduceInputRecords  OutputRecords  FileBytesRead FileBytesWritten  HdfsBytesRead HdfsBytesWritten Alias	Feature	Outputs
2018-01-20 02:24:53.044 [info]   scope-1290 FAILED      100        100       44005479                    0       33798212         335808         83480574              0                0 ... MULTI_QUERY
```

The Pig script consumes hourly data. It fails for some hours but not for others. In order to locate and to understand the problem, the first thing to do is to reproduce the issue with the same input data, which almost always makes sense, and was fairly straightforward in my case.

### What does not work

Since the problem only occurs for some hours, it could be related to some corrupt input data in those hours. However, bisecting the input data for a particular hour didn't help me to locate the root cause.

Another suspect was the JVM reuse introduced in newer versions of Hadoop. I played around with the `mapred.job.reuse.jvm.num.tasks` parameter, which was default to 20 on EMR (yeah the Pig script runs on EMR), without success.

The UDF alias `lookupUserName` is used multiple times in the Pig script. Could that cause some concurrency issues? Therefore I made the `exec` method a `synchronized` one, which didn't fix the issue. Registering the UDF twice, under different aliases, e.g., `lookupUserName1` and `lookupUserName2`, didn't fix the issue either.

### What works

Reducing the text file size did the trick. What also worked was splitting the Pig script and make two scripts out of it, each defining its own alias of the UDF. But these two methods were more like investigations for the understanding of the problem than they are suitable as a workaround or solution. Especially reducing the text file size is not possible for my use case.

What could be consiered as workarounds are: 1. switching the computation engine from Tez to MapReduce, or 2. changing the instance type from m3 to m4. In both cases the issue didn't happen.

In the end, I opted to manipulate the mapper container size as follows:

`pig -Dmapreduce.map.java.opts=-Xmx2304m -Dmapreduce.map.memory.mb=2880 -stop_on_failure -x tez ...`

The parameters `mapreduce.map.memory.mb` and `mapreduce.map.java.opts` specify the _physical memory limit_ and _JVM heap space limit_ of the _mapper_ containers used by this application. Similarly, `mapreduce.reduce.memory.mb` `mapreduce.reduce.java.opts` specify the memory usage of the _reducer_ containers. If not specified, the cluster default will be used. As an example, for an EMR cluster based on `m3.xlarge` instances, we have the following default settings:

```
Physical memory limits (P):
- mapreduce.map.memory.mb 1440
- mapreduce.reduce.memory.mb 2880

JVM heap space limits (H):
- mapreduce.map.java.opts Xmx1152m
- mapreduce.reduce.java.opts -Xmx2304m
```

The ratio between `P` and `H` is by default `P * 0.8 = H`. The ratio shall be kept when changing the container size, i.e., usually `P` and `H` shall be specified at the same time, unless you really know what you are doing.

For the same EMR cluster, other interesting memory and container-size related defaults are:

```
yarn.app.mapreduce.am.resource.mb 2880
yarn.scheduler.minimum-allocation-mb 32
yarn.scheduler.maximum-allocation-mb 11520
yarn.nodemanager.resource.memory-mb 11520
```

The parameter `yarn.nodemanager.resource.memory-mb` specifies the amount of physical memory available to the node manager on a single data node. Together with the parameter `yarn.app.mapreduce.am.resource.mb` they specify the maximum number of containers which can be used for application masters (AMs) on each data node. In our case, it is

```
Number of AMs (per node): 11520 / 2880 = 4
```

That is, if all memory resources are used by the AMs, we can have 4 of them running in parallel. By controlling that number, we basically control the concurrent running YARN applications.

The parameters `yarn.scheduler.minimum-allocation-mb` and `yarn.scheduler.maximum-allocation-mb` specify the memory chunk sizes which can be allocated by the node manager. In our case, it means the data node can have between 1 and 360 containers (`11520/11520 = 1` and `11520/32=360`).

### Summary

The issue was actually caused by a natural increase of the text file size. Thats why the things tried in the last section did the trick. All of them were in a way changing the memory usage. In this case, increasing the container size (scaling up vertically) is the simple and correct solution. Of cause the issue could have been dealt with by replacing the UDF by join in Pig. But that would require much more effort.
