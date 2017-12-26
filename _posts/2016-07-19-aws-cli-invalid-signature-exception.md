---
layout: post
title:  "AWS CLI InvalidSignatureException in a Docker container"
date:   2016-07-19 07:42:30 +0000
last_modified_at: 2017-11-07 07:52:44
category: post
tags: [AWS, Docker]
---

I had this issue using awscli in a Docker container:

```
An error occurred (InvalidSignatureException) when calling the ListInstances operation: Signature expired: 20160718T233827Z is now earlier than 20160719T083223Z (20160719T083723Z - 5 min.)
```

It seems that AWS requires the client's system time to be closely in sync with the server side. Only a small time difference of _five minutes_ is allowed. My Docker daemon had not been restarted for days and that have resulted in the stale system time in the container. That seems to be a bug of the _docker for mac_ beta:

```
Version 1.12.0-rc4-beta19 (build: 10258)
c84feba3aa680f426b8fa66f688388611267cd53
```

Restarting the Docker daemon and the container solved the issue. 

The related software versions within the container are:

```
$ aws --version
aws-cli/1.10.47 Python/2.7.5 Linux/4.4.15-moby botocore/1.4.37
$ cat /etc/redhat-release 
CentOS Linux release 7.2.1511 (Core) 
```
