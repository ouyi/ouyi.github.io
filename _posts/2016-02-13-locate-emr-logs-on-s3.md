---
layout: post
title:  "Locate EMR application logs on Amazon S3"
date:   2016-02-13 07:15:00 +0000
last_modified_at: 2016-02-13 07:15:00 +0000
category: post
tags: [AWS, Cloud, Big Data]
---

* TOC
{:toc}
Log files are extremely useful for finding the root cause of a failed YARN application. This naturally also applies to any EMR application. As a distributed framework, Hadoop generates a lot of log files, even for a single application. Understanding how the log files are organized helps to locate the log files of interest quickly.

## Why EMR log files on S3

In my experience, it is a best practice to treat any EMR cluster as a **transient cluster**, which is created on demand and terminated after the computation jobs are finished. In general, it is a **good habit** to terminate the EMR cluster often. Some times it is more **cost effective** to have the cluster running continuously than terminating it multiple times a day. But even in that case, one shall still consider to periodically terminate the cluster and spin up a new one, e.g., on a daily or weekly basis.

Forming such a habit has two benefits:
1. it forces you to automate everything and design the data flow in a way that it doesn't assume a long-running EMR cluster;
2. it helps to detect infrastructure issues early and frequently.

Therefore, I strongly recommend terminating the EMR clusters regularly, and consequently, I also recommend enabling log archiving when creating an EMR cluster. With that enabled, EMR log files will be periodically (every five minutes) archived to S3. Those files are available for as long as the S3 bucket's lifecycle policy allows, even when the EMR cluster which created those logs is already terminated.

## How to enable it

To enable the log archiving to S3, use the `--log-uri` option of the [`create-cluster` command from awscli](https://docs.aws.amazon.com/cli/latest/reference/emr/create-cluster.html), e.g.[^alternative_method],

```
aws emr create-cluster --log-uri s3://mybucket/log ...
```

The structure of the EMR logs on S3 are [described here](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-manage-view-web-log-files.html#emr-manage-view-web-log-files-s3).

## Example

To demonstrate how to find the relevant log files for a particular application, assuming we have the following information to narrow down our search scope:

```
S3 bucket = mybucket
cluster id = j-2GF2QHPPT1LD8
year/month/date = 2015/12/22
mapreduce job id = 1449769331686_17998
```

### Application-level logs

All history logs for the mapreduce job can be found by this command:

```
aws s3 ls s3://mybucket/log/j-2GF2QHPPT1LD8/hadoop-mapreduce/history/2015/12/22/ --recursive | grep job_1449769331686_17998
```

The per-container application logs can be found this way:

```
aws s3 ls s3://mybucket/log/j-2GF2QHPPT1LD8/containers/application_1449769331686_17998/
```

Among them, the YARN Application Master is normally run in the first container, so its logs are, for example, here:

```
aws s3 ls s3://mybucket/log/j-2GF2QHPPT1LD8/containers/application_1449769331686_17998/container_1449769331686_17998_01_000001/
2015-12-22 02:06:51        668 stderr.gz
2015-12-22 02:06:51         20 stdout.gz
2015-12-22 04:59:22    2563624 syslog.gz
```

### Resource manager logs

Resource manager log files are sorted by date-hour, for example:

```
aws s3 ls s3://mybucket/log/j-2GF2QHPPT1LD8/node/i-8063b809/applications/hadoop-yarn/ | grep -i resource | tail
2015-12-21 21:05:52   10535235 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-21-19.gz
2015-12-21 22:05:48   13197249 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-21-20.gz
2015-12-21 23:05:46   12911419 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-21-21.gz
2015-12-22 00:05:41   12973568 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-21-22.gz
2015-12-22 01:05:39   12696814 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-21-23.gz
2015-12-22 02:05:30   12912600 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-22-00.gz
2015-12-22 03:05:21   13319589 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-22-01.gz
2015-12-22 04:05:03    6768662 yarn-yarn-resourcemanager-ip-172-31-11-61.log.2015-12-22-02.gz
2015-12-22 04:59:14    9952101 yarn-yarn-resourcemanager-ip-172-31-11-61.log.gz
2015-12-14 11:32:22        648 yarn-yarn-resourcemanager-ip-172-31-11-61.out.gz
```

Here `i-8063b809` is the instance id of the master node.

### Full-text search

It is possible to download all log files for a particular application or a particular container from S3 and then use the standard Unix/Linux tools to do a fulltext search (AWS has probably native tools for direct full-text search on S3, which is not the focus of this post).

```
hadoop fs -copyToLocal s3://mybucket/log/j-2GF2QHPPT1LD8/containers/application_1449769331686_17998/ .

find -name "*.gz" -print0 | xargs -0 zgrep "Exception"
```

## Footnotes
[^alternative_method]: It is of course also possible to enable log archiving using the AWS Console or the API.
