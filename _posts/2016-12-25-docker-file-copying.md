---
layout: post
title:  "Ad hoc file copying between host and Docker container"
date:   2016-12-25 07:44:35 +0000
category: cicd
tags: [Docker, CI/CD]
---

**Contents**
* TOC
{:toc}
Docker supports file sharing between the host and a container via the `-v` option, which allows a host directory to be accessible within the container at the specified mount point, For example, with `docker run -v /path_on_the_host:/path_in_the_container postgres`, the host directory `/path_on_the_host` can be accessed as `/path_in_the_container` within the container. However, this requires the container being started already with the `-v` option.

Can we copy files to and from a running container, which was started without `-v`, _without restarting_ it? Here is how to do that with _piping_.

## Preparation

To test the solution, lets first start a postgres container from the official images:

```
$ docker run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=secret -d postgres
```

Assuming we want to execute some SQL queries against our postgres database in the container, and the queries are in a file, e.g., 

```
$ cat /tmp/version.sql
SELECT VERSION();
```

## Piping a file into a container

```
$ cat /tmp/version.sql | docker exec -i -u 0 postgres /bin/bash -c 'cat > /tmp/version.sql'
```

## Reading a file out of the container

```
$ docker exec -i -u 0 postgres /bin/bash -c 'cat /tmp/version.sql'
SELECT VERSION();
```

## Reading the file within the container

```
$ docker exec -i -u 0 postgres bash -c 'psql -h localhost -f /tmp/version.sql -U postgres'
                                         version                                          
------------------------------------------------------------------------------------------
 PostgreSQL 9.6.1 on x86_64-pc-linux-gnu, compiled by gcc (Debian 4.9.2-10) 4.9.2, 64-bit
(1 row)
```

Just for completness, the above trivial example use case can also be fullfiled by directly piping the file content to psql, without using the temporary file, e.g.,

```
echo 'SELECT VERSION();' | docker exec -i -u 0 postgres bash -c 'psql -h localhost -U postgres'
```

## Update 2017-01-14

It turns out that Docker has builtin support for file (and even folder) copying to and from a running container, using the `docker cp` command, which is really cool! 

### Prepare test data

```
$ mkdir /tmp/test
$ echo 'Hello world!' > /tmp/test/test.txt
```

### Copy from host to container

```
$ docker cp /tmp/test/ postgres:/tmp/
$ docker exec -i -u 0 postgres /bin/bash -c 'ls -l /tmp/test/'
total 4
-rw-rw-r--. 1 root root 13 Jan 14 14:56 test.txt
```

### Copy from container to host

```
$ docker cp postgres:/tmp/test/test.txt /tmp/test.txt
$ cat /tmp/test.txt
Hello world!
```

_Happy dockering!_

