---
layout: post
title:  "Hadoop streaming broken pipe issue"
date:   2015-12-06 19:11:04 +0000
last_modified_at: 2017-11-04 08:58:35
category: hadoop
tags: [Big Data, Hadoop Streaming]
---

I was working on a simple tool (a distributed `grep`) using Hadoop streaming in Bash. Everything works fine when testing locally with the standard approach:

{% highlight bash %}
cat input | ./mapper.sh | sort | ./reducer.sh
{% endhighlight %}

However, when I ran the program on a larger input in a single-node cluster, I kept getting the following error:

```
Streaming Job Failed!
```

The command used to run the Hadoop streaming job was:

{% highlight bash %}
hadoop jar contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.0.1.jar \
-mapper '/tmp/mapper.sh Exception' \
-reducer /tmp/reducer.sh \
-input /tmp/input \
-output /tmp/output
{% endhighlight %}

The log shows:

```
java.io.IOException: Broken pipe
    at java.io.FileOutputStream.writeBytes(Native Method)
    at java.io.FileOutputStream.write(FileOutputStream.java:282)
    at java.io.BufferedOutputStream.write(BufferedOutputStream.java:105)
    at java.io.BufferedOutputStream.flushBuffer(BufferedOutputStream.java:65)
    at java.io.BufferedOutputStream.write(BufferedOutputStream.java:109)
    at java.io.DataOutputStream.write(DataOutputStream.java:90)
    at org.apache.hadoop.streaming.io.TextInputWriter.writeUTF8(TextInputWriter.java:72)
    at org.apache.hadoop.streaming.io.TextInputWriter.writeValue(TextInputWriter.java:51)
    at org.apache.hadoop.streaming.PipeMapper.map(PipeMapper.java:109)
    at org.apache.hadoop.mapred.MapRunner.run(MapRunner.java:50)
    at org.apache.hadoop.streaming.PipeMapRunner.run(PipeMapRunner.java:36)
    at org.apache.hadoop.mapred.MapTask.runOldMapper(MapTask.java:441)
    at org.apache.hadoop.mapred.MapTask.run(MapTask.java:377)
    at org.apache.hadoop.mapred.Child$4.run(Child.java:255)
    at java.security.AccessController.doPrivileged(Native Method)
    at javax.security.auth.Subject.doAs(Subject.java:396)
    at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1059)
    at org.apache.hadoop.mapred.Child.main(Child.java:249)
```

The root cause is that mapper.sh was not fully consuming its input. See the [related post on stackoverflow](http://stackoverflow.com/questions/9881269/broken-pipe-error-causes-streaming-elastic-mapreduce-job-on-aws-to-fail) and a [related issue](https://issues.apache.org/jira/browse/MAPREDUCE-3790).

This is the original mapper.sh that fails:

{% highlight bash %}
#!/usr/bin/env bash

content_pattern="$1"

if grep -qE "$content_pattern" ; then echo "$map_input_file" ; fi
{% endhighlight %}

This is the mapper.sh that works:

{% highlight bash %}
#!/usr/bin/env bash

content_pattern="$1"

cat - | if grep -qE "$content_pattern" ; then echo "$map_input_file" ; fi
{% endhighlight %}

The only difference to the original script is the added `cat -` part, which makes sure that the input stream to the mapper script is fully consumed. It seems that grep does not always need to see its full input to determine its exit code (this is possible, e.g., if the remaining number of bytes in the input stream is smaller than the length of the shortest string that could match the pattern). 

For completeness, the reducer.sh code:

{% highlight bash %}
#!/usr/bin/env bash

while read curr_line ; do
    if [[ "$last_line" != "$curr_line" ]]; then
        echo "$curr_line"
        last_line="$curr_line"
    fi
done
{% endhighlight %}

The mapper outputs the input file name if its content matches the pattern. The reducer just removes potential duplicates. 

![hadoop-logo](https://user-images.githubusercontent.com/15970333/102699853-874d4a00-4248-11eb-8d50-302b5ebc7b57.jpg "Apache Hadoop logo")
