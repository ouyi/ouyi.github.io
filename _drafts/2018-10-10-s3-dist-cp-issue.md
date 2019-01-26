---
layout: post
title:  "s3-dist-cp issue with a single file as destination"
date:   2018-10-10 07:15:00 +0000
last_modified_at: 2018-10-10 07:15:00 +0000
category: post
tags: [Cloud]
---


echo test1 > test1.txt

hadoop fs -copyFromLocal test1.txt /tmp/

s3-dist-cp --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/

s3-dist-cp --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/
18/10/10 10:40:47 INFO s3distcp.S3DistCp: Running with args: -libjars /usr/share/aws/emr/s3-dist-cp/lib/guava-15.0.jar,/usr/share/aws/emr/s3-dist-cp/lib/s3-dist-cp-2.4.0.jar,/usr/share/aws/emr/s3-dist-cp/lib/s3-dist-cp.jar --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/
18/10/10 10:40:48 INFO s3distcp.S3DistCp: S3DistCp args: --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/
18/10/10 10:40:48 INFO s3distcp.S3DistCp: Using output path 'hdfs:/tmp/a04c6dae-e529-4dff-a0c4-ca6c140ed225/output'
18/10/10 10:40:48 INFO s3distcp.S3DistCp: GET http://169.254.169.254/latest/meta-data/placement/availability-zone result: us-east-1a
18/10/10 10:40:48 INFO s3distcp.FileInfoListing: Opening new file: hdfs:/tmp/a04c6dae-e529-4dff-a0c4-ca6c140ed225/files/1
18/10/10 10:40:48 INFO s3distcp.S3DistCp: Created 1 files to copy 1 files
18/10/10 10:40:51 INFO s3distcp.S3DistCp: Reducer number: 483
18/10/10 10:40:51 INFO impl.TimelineClientImpl: Timeline service address: http://ip-10-192-0-233.ec2.internal:8188/ws/v1/timeline/
18/10/10 10:40:51 INFO client.RMProxy: Connecting to ResourceManager at ip-10-192-0-233.ec2.internal/10.192.0.233:8032
18/10/10 10:40:51 INFO input.FileInputFormat: Total input paths to process : 1
18/10/10 10:40:52 INFO mapreduce.JobSubmitter: number of splits:1
18/10/10 10:40:52 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1539165399456_0003
18/10/10 10:40:52 INFO impl.YarnClientImpl: Submitted application application_1539165399456_0003
18/10/10 10:40:52 INFO mapreduce.Job: The url to track the job: http://ip-10-192-0-233.ec2.internal:20888/proxy/application_1539165399456_0003/
18/10/10 10:40:52 INFO mapreduce.Job: Running job: job_1539165399456_0003
18/10/10 10:40:57 INFO mapreduce.Job: Job job_1539165399456_0003 running in uber mode : false
18/10/10 10:40:57 INFO mapreduce.Job:  map 0% reduce 0%
18/10/10 10:41:01 INFO mapreduce.Job:  map 100% reduce 0%
18/10/10 10:41:07 INFO mapreduce.Job:  map 100% reduce 5%
18/10/10 10:41:08 INFO mapreduce.Job:  map 100% reduce 23%
18/10/10 10:41:09 INFO mapreduce.Job:  map 100% reduce 34%
18/10/10 10:41:10 INFO mapreduce.Job:  map 100% reduce 40%
18/10/10 10:41:11 INFO mapreduce.Job:  map 100% reduce 53%
18/10/10 10:41:12 INFO mapreduce.Job:  map 100% reduce 64%
18/10/10 10:41:13 INFO mapreduce.Job:  map 100% reduce 93%
18/10/10 10:41:14 INFO mapreduce.Job:  map 100% reduce 98%
18/10/10 10:41:15 INFO mapreduce.Job:  map 100% reduce 100%
18/10/10 10:41:17 INFO mapreduce.Job: Job job_1539165399456_0003 completed successfully
18/10/10 10:41:17 INFO mapreduce.Job: Counters: 54
	File System Counters
		FILE: Number of bytes read=9780
		FILE: Number of bytes written=63662071
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=399
		HDFS: Number of bytes written=0
		HDFS: Number of read operations=1454
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=966
		S3: Number of bytes read=0
		S3: Number of bytes written=6
		S3: Number of read operations=0
		S3: Number of large read operations=0
		S3: Number of write operations=0
	Job Counters
		Launched map tasks=1
		Launched reduce tasks=483
		Rack-local map tasks=1
		Total time spent by all maps in occupied slots (ms)=115008
		Total time spent by all reduces in occupied slots (ms)=173588448
		Total time spent by all map tasks (ms)=2396
		Total time spent by all reduce tasks (ms)=1808213
		Total vcore-milliseconds taken by all map tasks=2396
		Total vcore-milliseconds taken by all reduce tasks=1808213
		Total megabyte-milliseconds taken by all map tasks=3680256
		Total megabyte-milliseconds taken by all reduce tasks=5554830336
	Map-Reduce Framework
		Map input records=1
		Map output records=1
		Map output bytes=132
		Map output materialized bytes=7848
		Input split bytes=154
		Combine input records=0
		Combine output records=0
		Reduce input groups=1
		Reduce shuffle bytes=7848
		Reduce input records=1
		Reduce output records=0
		Spilled Records=2
		Shuffled Maps =483
		Failed Shuffles=0
		Merged Map outputs=483
		GC time elapsed (ms)=46604
		CPU time spent (ms)=480580
		Physical memory (bytes) snapshot=128122662912
		Virtual memory (bytes) snapshot=2248749428736
		Total committed heap usage (bytes)=205351026688
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters
		Bytes Read=239
	File Output Format Counters
		Bytes Written=0
18/10/10 10:41:17 INFO s3distcp.S3DistCp: Try to recursively delete hdfs:/tmp/a04c6dae-e529-4dff-a0c4-ca6c140ed225/tempspace

aws s3 ls s3://mybucket/temp/
                           PRE repo/
2018-02-08 15:53:58        244 READ_ME.txt
2018-05-16 06:08:17          0 ouyi_$folder$
2018-05-03 15:42:29      14078 cpuid.txt
2018-03-28 14:34:21          0 hello.txt_$folder$
2018-10-06 19:04:57          0 test.data_$folder$
2018-10-10 10:41:15          6 test1.txt
2018-10-10 10:39:12          0 test_$folder$

hadoop fs -cat s3://mybucket/temp/test1.txt
test1



s3-dist-cp --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/test1.txt
18/10/10 10:46:18 INFO s3distcp.S3DistCp: Running with args: -libjars /usr/share/aws/emr/s3-dist-cp/lib/guava-15.0.jar,/usr/share/aws/emr/s3-dist-cp/lib/s3-dist-cp-2.4.0.jar,/usr/share/aws/emr/s3-dist-cp/lib/s3-dist-cp.jar --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/test1.txt
18/10/10 10:46:18 INFO s3distcp.S3DistCp: S3DistCp args: --s3ServerSideEncryption --src=/tmp/test1.txt --dest=s3://mybucket/temp/test/test1.txt
18/10/10 10:46:18 INFO s3distcp.S3DistCp: Using output path 'hdfs:/tmp/0ae0f766-dc77-49e9-9ecd-26a5089705d2/output'
18/10/10 10:46:18 INFO s3distcp.S3DistCp: GET http://169.254.169.254/latest/meta-data/placement/availability-zone result: us-east-1a
18/10/10 10:46:19 INFO s3distcp.FileInfoListing: Opening new file: hdfs:/tmp/0ae0f766-dc77-49e9-9ecd-26a5089705d2/files/1
18/10/10 10:46:19 INFO s3distcp.S3DistCp: Created 1 files to copy 1 files
18/10/10 10:46:21 INFO s3distcp.S3DistCp: Reducer number: 483
18/10/10 10:46:22 INFO impl.TimelineClientImpl: Timeline service address: http://ip-10-192-0-233.ec2.internal:8188/ws/v1/timeline/
18/10/10 10:46:22 INFO client.RMProxy: Connecting to ResourceManager at ip-10-192-0-233.ec2.internal/10.192.0.233:8032
18/10/10 10:46:22 INFO input.FileInputFormat: Total input paths to process : 1
18/10/10 10:46:22 INFO mapreduce.JobSubmitter: number of splits:1
18/10/10 10:46:22 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1539165399456_0004
18/10/10 10:46:22 INFO impl.YarnClientImpl: Submitted application application_1539165399456_0004
18/10/10 10:46:22 INFO mapreduce.Job: The url to track the job: http://ip-10-192-0-233.ec2.internal:20888/proxy/application_1539165399456_0004/
18/10/10 10:46:22 INFO mapreduce.Job: Running job: job_1539165399456_0004
18/10/10 10:46:27 INFO mapreduce.Job: Job job_1539165399456_0004 running in uber mode : false
18/10/10 10:46:27 INFO mapreduce.Job:  map 0% reduce 0%
18/10/10 10:46:32 INFO mapreduce.Job:  map 100% reduce 0%
18/10/10 10:46:37 INFO mapreduce.Job:  map 100% reduce 10%
18/10/10 10:46:38 INFO mapreduce.Job:  map 100% reduce 25%
18/10/10 10:46:39 INFO mapreduce.Job:  map 100% reduce 35%
18/10/10 10:46:40 INFO mapreduce.Job:  map 100% reduce 39%
18/10/10 10:46:41 INFO mapreduce.Job:  map 100% reduce 54%
18/10/10 10:46:42 INFO mapreduce.Job:  map 100% reduce 72%
18/10/10 10:46:43 INFO mapreduce.Job:  map 100% reduce 95%
18/10/10 10:46:44 INFO mapreduce.Job:  map 100% reduce 100%
18/10/10 10:47:08 INFO mapreduce.Job: Job job_1539165399456_0004 failed with state FAILED due to: Task failed task_1539165399456_0004_r_000478
Job failed as tasks failed. failedMaps:0 failedReduces:1

18/10/10 10:47:08 INFO mapreduce.Job: Counters: 50
	File System Counters
		FILE: Number of bytes read=9640
		FILE: Number of bytes written=63540123
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=403
		HDFS: Number of bytes written=0
		HDFS: Number of read operations=1450
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=964
	Job Counters
		Failed reduce tasks=4
		Launched map tasks=1
		Launched reduce tasks=486
		Rack-local map tasks=1
		Total time spent by all maps in occupied slots (ms)=120816
		Total time spent by all reduces in occupied slots (ms)=170560032
		Total time spent by all map tasks (ms)=2517
		Total time spent by all reduce tasks (ms)=1776667
		Total vcore-milliseconds taken by all map tasks=2517
		Total vcore-milliseconds taken by all reduce tasks=1776667
		Total megabyte-milliseconds taken by all map tasks=3866112
		Total megabyte-milliseconds taken by all reduce tasks=5457921024
	Map-Reduce Framework
		Map input records=1
		Map output records=1
		Map output bytes=142
		Map output materialized bytes=7853
		Input split bytes=154
		Combine input records=0
		Combine output records=0
		Reduce input groups=0
		Reduce shuffle bytes=7712
		Reduce input records=0
		Reduce output records=0
		Spilled Records=1
		Shuffled Maps =482
		Failed Shuffles=0
		Merged Map outputs=482
		GC time elapsed (ms)=46834
		CPU time spent (ms)=475500
		Physical memory (bytes) snapshot=127764099072
		Virtual memory (bytes) snapshot=2244102078464
		Total committed heap usage (bytes)=203607244800
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters
		Bytes Read=249
	File Output Format Counters
		Bytes Written=0
18/10/10 10:47:08 INFO s3distcp.S3DistCp: Try to recursively delete hdfs:/tmp/0ae0f766-dc77-49e9-9ecd-26a5089705d2/tempspace
18/10/10 10:47:08 ERROR s3distcp.S3DistCp: The MapReduce job failed: Task failed task_1539165399456_0004_r_000478
Job failed as tasks failed. failedMaps:0 failedReduces:1

Exception in thread "main" java.lang.RuntimeException: The MapReduce job failed: Task failed task_1539165399456_0004_r_000478
Job failed as tasks failed. failedMaps:0 failedReduces:1

	at com.amazon.elasticmapreduce.s3distcp.S3DistCp.run(S3DistCp.java:918)
	at com.amazon.elasticmapreduce.s3distcp.S3DistCp.run(S3DistCp.java:705)
	at org.apache.hadoop.util.ToolRunner.run(ToolRunner.java:70)
	at org.apache.hadoop.util.ToolRunner.run(ToolRunner.java:84)
	at com.amazon.elasticmapreduce.s3distcp.Main.main(Main.java:22)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.apache.hadoop.util.RunJar.run(RunJar.java:221)
	at org.apache.hadoop.util.RunJar.main(RunJar.java:136)


[hadoop@ip-10-192-0-233 ~]$ hadoop fs -ls s3://mybucket/temp/test/
Found 1 items
drwxrwxrwx   -          0 1970-01-01 00:00 s3://mybucket/temp/test/test1.txt
[hadoop@ip-10-192-0-233 ~]$ hadoop fs -cat s3://mybucket/temp/test/test1.txt
cat: `s3://mybucket/temp/test/test1.txt': Is a directory

hadoop fs -copyToLocal s3://mybucket/log/j-2CG8YCYXOL9KO/containers/application_1539165399456_0004/ .

find -name "*.gz" -print0 | xargs -0 zgrep "Exception"

[hadoop@ip-10-192-0-233 ~]$ find -name "*.gz" -print0 | xargs -0 zgrep "Exception"
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,576 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=9
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,631 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=8
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,671 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=7
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,716 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=6
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,768 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=5
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,808 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=4
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,858 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=3
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:58,973 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=2
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:59,016 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=1
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:59,060 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=0
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz:2018-10-10 10:46:59,197 WARN [main] org.apache.hadoop.mapred.YarnChild: Exception running child : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:05,768 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=9
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:05,816 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=8
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:05,858 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=7
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:05,894 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=6
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:05,930 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=5
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:05,970 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=4
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:06,009 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=3
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:06,044 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=2
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:06,086 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=1
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:06,124 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=0
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000562/syslog.gz:2018-10-10 10:47:06,249 WARN [main] org.apache.hadoop.mapred.YarnChild: Exception running child : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,620 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=9
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,663 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=8
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,700 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=7
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,738 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=6
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,779 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=5
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,817 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=4
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,854 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=3
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,912 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=2
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,955 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=1
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:51,995 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=0
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000560/syslog.gz:2018-10-10 10:46:52,113 WARN [main] org.apache.hadoop.mapred.YarnChild: Exception running child : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/stderr.gz:INFO: Registering org.apache.hadoop.yarn.webapp.GenericExceptionHandler as a provider class
./application_1539165399456_0004/container_1539165399456_0004_01_000001/stderr.gz:INFO: Binding org.apache.hadoop.yarn.webapp.GenericExceptionHandler to GuiceManagedComponentProvider with the scope "Singleton"
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:45,188 ERROR [IPC Server handler 57 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Task: attempt_1539165399456_0004_r_000478_0 - exited : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:45,188 INFO [IPC Server handler 57 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_0: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:45,188 INFO [AsyncDispatcher event handler] org.apache.hadoop.mapreduce.v2.app.job.impl.TaskAttemptImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_0: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:52,099 ERROR [IPC Server handler 21 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Task: attempt_1539165399456_0004_r_000478_1 - exited : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:52,099 INFO [IPC Server handler 21 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_1: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:52,099 INFO [AsyncDispatcher event handler] org.apache.hadoop.mapreduce.v2.app.job.impl.TaskAttemptImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_1: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:59,183 ERROR [IPC Server handler 0 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Task: attempt_1539165399456_0004_r_000478_2 - exited : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:59,183 INFO [IPC Server handler 0 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_2: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:46:59,183 INFO [AsyncDispatcher event handler] org.apache.hadoop.mapreduce.v2.app.job.impl.TaskAttemptImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_2: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:47:06,240 ERROR [IPC Server handler 33 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Task: attempt_1539165399456_0004_r_000478_3 - exited : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:47:06,240 INFO [IPC Server handler 33 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_3: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz:2018-10-10 10:47:06,240 INFO [AsyncDispatcher event handler] org.apache.hadoop.mapreduce.v2.app.job.impl.TaskAttemptImpl: Diagnostics report from attempt_1539165399456_0004_r_000478_3: Error: java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,417 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=9
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,504 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=8
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,617 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=7
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,661 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=6
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,707 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=5
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,901 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=4
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,941 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=3
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:44,982 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=2
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:45,021 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=1
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:45,061 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=0
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
./application_1539165399456_0004/container_1539165399456_0004_01_000481/syslog.gz:2018-10-10 10:46:45,197 WARN [main] org.apache.hadoop.mapred.YarnChild: Exception running child : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc

vim ./application_1539165399456_0004/container_1539165399456_0004_01_000561/syslog.gz

2018-10-10 10:46:58,576 WARN [s3distcp-simpler-executor-worker-4] com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable: Exception raised while copying file data to file=s3://mybucket/temp/test/test1.txt numRetriesRemaining=9
java.io.IOException: Path already exists as a directory: s3://mybucket/temp/test/test1.txt
        at com.amazon.ws.emr.hadoop.fs.consistency.ConsistencyCheckerS3FileSystem.create(ConsistencyCheckerS3FileSystem.java:174)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at org.apache.hadoop.io.retry.RetryInvocationHandler.invokeMethod(RetryInvocationHandler.java:191)
        at org.apache.hadoop.io.retry.RetryInvocationHandler.invoke(RetryInvocationHandler.java:102)
        at com.sun.proxy.$Proxy34.create(Unknown Source)
        at com.amazon.ws.emr.hadoop.fs.s3n2.S3NativeFileSystem2.create(S3NativeFileSystem2.java:120)
        at org.apache.hadoop.fs.FileSystem.create(FileSystem.java:915)
        at org.apache.hadoop.fs.FileSystem.create(FileSystem.java:896)
        at org.apache.hadoop.fs.FileSystem.create(FileSystem.java:793)
        at org.apache.hadoop.fs.FileSystem.create(FileSystem.java:782)
        at com.amazon.ws.emr.hadoop.fs.EmrFileSystem.create(EmrFileSystem.java:171)
        at com.amazon.elasticmapreduce.s3distcp.CopyFilesReducer.openOutputStream(CopyFilesReducer.java:319)
        at com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable.mergeAndCopyFiles(CopyFilesRunnable.java:98)
        at com.amazon.elasticmapreduce.s3distcp.CopyFilesRunnable.run(CopyFilesRunnable.java:35)
        at com.amazon.elasticmapreduce.s3distcp.SimpleExecutor$Worker.run(SimpleExecutor.java:49)
        at java.lang.Thread.run(Thread.java:745)

vim ./application_1539165399456_0004/container_1539165399456_0004_01_000001/syslog.gz

2018-10-10 10:46:45,188 ERROR [IPC Server handler 57 on 37168] org.apache.hadoop.mapred.TaskAttemptListenerImpl: Task: attempt_1539165399456_0004_r_000478_0 - exited : java.lang.RuntimeException: Reducer task failed to copy 1 files: hdfs://ip-10-192-0-233.ec2.internal:8020/tmp/test1.txt etc
        at com.amazon.elasticmapreduce.s3distcp.CopyFilesReducer.cleanup(CopyFilesReducer.java:67)
        at org.apache.hadoop.mapreduce.Reducer.run(Reducer.java:179)
        at org.apache.hadoop.mapred.ReduceTask.runNewReducer(ReduceTask.java:635)
        at org.apache.hadoop.mapred.ReduceTask.run(ReduceTask.java:390)
        at org.apache.hadoop.mapred.YarnChild$2.run(YarnChild.java:164)
        at java.security.AccessController.doPrivileged(Native Method)
        at javax.security.auth.Subject.doAs(Subject.java:422)
        at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1698)
        at org.apache.hadoop.mapred.YarnChild.main(YarnChild.java:158)
