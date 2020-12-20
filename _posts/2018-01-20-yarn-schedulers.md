---
layout: post
title:  "YARN的任务调度机制"
date:   2018-01-20 14:32:27 +0000
last_modified_at: 2018-01-20 22:39:27
category: post
tags: [Big Data]
lang: zh
ref: yarn-schedulers
---

* TOC
{:toc}
最近单位的Hadoop集群发生了死锁问题 (deadlock)，于是对Hadoop的调度程序发生了兴趣。YARN支持可插拔的任务调度器（严格来说也许应该叫资源分配器）。官方文档里面讲了两种：容量调度器 (capacity scheduler) 和公平调度器 (fair scheduler)。默认的是容量调度器。下面是啃完文档后的一点总结，浓缩的都是精华 :wink:。

## 容量调度器

容量调度器旨在允许多组织（或者多用户）共享大型集群，最大限度地提高集群的吞吐量和利用率，同时为每个组织提供容量保证。

### 层次化队列

容量调度器支持层次化队列结构，以确保在其他队列被允许使用闲置资源之前，在组织的子队列之间共享资源，从而提供更多的控制和可预测性。

下面这个例子里，a，b，和c都是根队列的子队列，a和b还分别定义了自己的子队列：
```
<property>
  <name>yarn.scheduler.capacity.root.queues</name>
  <value>a,b,c</value>
  <description>The queues at the this level (root is the root queue).
  </description>
</property>

<property>
  <name>yarn.scheduler.capacity.root.a.queues</name>
  <value>a1,a2</value>
  <description>The queues at the this level (root is the root queue).
  </description>
</property>

<property>
  <name>yarn.scheduler.capacity.root.b.queues</name>
  <value>b1,b2,b3</value>
  <description>The queues at the this level (root is the root queue).
  </description>
</property>
```

### 容量和弹性

容量调度器同时兼顾容量保证和弹性。

- 容量保证: 队列被分配一定量的可支配的资源。资源可以由集群容量的百分比来表示。
- 弹性：闲置资源可以分配给任何队列，也就是说队列可以使用超出其容量的资源。

这就确保资源以可预测的和弹性的方式提供给队列，从而防止集群中资源的人为孤岛，以提高利用率。

两个相关的重要参数：

- `yarn.scheduler.capacity.<queue-path>.capacity` 队列容量，用占集群总容量的百分比来表示。所有队列的容量合必须等于100。
- `yarn.scheduler.capacity.<queue-path>.maximum-capacity` 队列最大容量，允许超过队列容量，以便能够使用其它队列的闲置资源。

表达式`<queue-path>`是队列的路径，比如上面例子里面队列a1的路径为`root.a.a1`。

上面说到，队列可以使用超出其容量的资源。从运行容量低于保证容量的队列中再请求这些资源时，就要等目前使用这些资源的任务完成，或者不等它们完成就逐步地从资源使用量超过其保证容量的队列中强夺资源。资源的强夺以容器为单位。资源强夺英文叫preemption，是指不等待资源使用者释放资源而强行把资源抢夺过来。

跟资源强夺相关的重要参数：

- `yarn.resourcemanager.scheduler.monitor.enable` 要激活资源强夺，必须将此值设置为`true`。
- `yarn.resourcemanager.scheduler.monitor.policies` 这里必须是一个跟调度器兼容的策略，默认的策略`org.apache.hadoop.yarn.server.resourcemanager.monitor.capacity.ProportionalCapacityPreemptionPolicy`与容量调度器兼容。
- `yarn.resourcemanager.monitor.capacity.preemption.monitoring_interval` 上述策略相邻两次调用之间等待的时间。
- `yarn.resourcemanager.monitor.capacity.preemption.max_wait_before_kill` 发出强夺容器请求和强行终止容器之间的最长等待时间。
- `yarn.scheduler.capacity.<queue-path>.disable_preemption` 可以将此配置设置为`true`以选择性地禁用从给定队列进行资源强夺。这样可以实现一定程度的队列之间的优先级。

值得一提的是，我从一些测试里观察到，资源强夺并未造成应用程序报错，可能是`max_wait_before_kill`相对比较长，也可能是Hadoop的容错机制起了作用。

### 并发度控制

并发度的控制可以通过下面两组参数来配置：

- `yarn.scheduler.capacity.maximum-applications / yarn.scheduler.capacity.<queue-path>.maximum-applications`
应用程序的数量的最大值。这是一个硬性的限制，超过这个限制，提交任何申请时，都会被拒绝（应用程序会出错退出）。
- `yarn.scheduler.capacity.maximum-am-resource-percent / yarn.scheduler.capacity.<queue-path>.maximum-am-resource-percent`
集群中可用于运行应用程序主控的资源的最大百分比。这个值间接控制并发活动应用程序的数量。这是一个柔性的限制。超过这个限制，提交的申请会被接受并在队列里面等候。

### 运行时配置

容量调度器支持运行时修改配置。管理员可以在集群运行时以安全的方式更改队列定义和属性（如容量，ACL），以最大限度地减少对用户的干扰。

- 管理员可以在运行时添加额外的队列 ，但在运行时不能删除队列。
- 管理员可以在运行时停止队列，以确保当现有的应用程序运行完成时，不会提交新的应用程序。 如果队列处于“已停止”状态，则不能将新应用程序提交给它或它的任何子队列 。现有的应用程序将继续完成，因此队列可以正常排空。
- 管理员也可以启动已停止的队列。

容量调度器的参数主要在capacity-scheduler.xml这个配置文件里。修改这个文件后，可以通过命令来更新队列配置。例如：

```
$ vi $HADOOP_CONF_DIR/capacity-scheduler.xml
$ $HADOOP_YARN_HOME/bin/yarn rmadmin -refreshQueues
```

另外，一小部分容量调度器相关的参数在yarn-site.xml这个配置文件里。修改这里面的配置可能需要重启资源管理器才能使修改生效。

## 公平调度器

公平调度器允许YARN应用程序公平地共享大型集群中的资源。旨在让短应用程序在合理的时间内完成，而长应用程序也能得到资源。与容量调度器相似，它也利用分层的队列结构来进行资源分配，这里不再赘述。值得一提的是，公平调度器也允许为队列分配保证的最小份额。而且当队列不需要保证的份额时，多余的份额会在其他正在运行的应用程序之间进行分配，这一点也与容量调度器相似。

### 调度策略

公平调度器支持可插拔的调度策略，并且支持为每个队列设置不同的调度策略。内置的调度策略有FIFO(FifoPolicy)，FAIR(FairSharePolicy)，和DRF(DominantResourceFairnessPolicy)。默认情况下，公平调度器只基于内存资源使用公平性调度策略 (FAIR)。它可以配置为主导资源公平策略 (DRF) 来调度内存和CPU。关于主导资源，我的理解就是瓶颈资源。

### 权重和优先级

权重用来确定每个应用程序或队列应该获得的资源的比例。权重体现了应用程序或队列之间的优先级。

两个权重相关的参数：

- 应用权重：`yarn.scheduler.fair.sizebasedweight` 是否根据应用程序的大小进行资源分配，而不是向所有应用程序提供相同多的资源而不考虑应用程序的大小。默认为`false`。
- 队列权重：`weight` 队列可以与其他队列不成比例地共享集群。权重默认为1，而权重为2的队列应该接收的资源量约为默认权重的两倍。

### 并发度控制

公平调度器默认允许所有应用程序运行，但也可以通过配置文件限制每个用户和每个队列运行的应用程序的数量。限制应用程序不会导致任何随后提交的应用程序失败。提交后的应用程序只能在队列中等待，直到某些应用程序完成。这一点跟容器调度器的相关特性不太一样。个人觉得公平调度器的处理更加友好一点。

### 运行时配置

公平调度器也支持运行时修改配置。公平调度器相关的参数存在于两个配置文件里：yarn-site.xml和分配文件。修改yarn-site.xml里面的配置可能需要重启资源管理器才能使修改生效。而分配文件由`yarn.scheduler.fair.allocation.file`来指定，默认是`fair-scheduler.xml`。分配文件每10秒重新加载一次，允许进行更改。

公平调度器支持将正在运行的应用程序移动到不同的队列中。这对于将重要的应用程序移动到更高优先级的队列或将不重要的应用程序移动到更低优先级的队列可能会有用。例如：

```
yarn application -movetoqueue appID -queue targetQueueName
```

## 相似和区别

### 两者的相似性

- 都是Hadoop的可插拔调度程序。
- 都支持分层的队列结构。
- 都支持队列层面上的最少资源保证。
- 都支持闲置资源的分配和利用。
- 都提供了一套限制来防止单个应用程序，用户和队列独占整个队列或集群的资源。
- 都支持对队列分配策略 (应用程序到队列的映射，一般是基于用户名或组名的一些规则) 进行配置。
- 都可以通过URL`https://<ResourceManager URL>/cluster/scheduler`查看队列资源的分配和使用情况。
- 都支持限制每个用户和每个队列运行的应用程序的数量，以防止死锁。
- 都支持资源的强夺，以防止死锁。

### 两者的区别

- 对优先级的支持：容量调度器只是通过给队列分配不同的保证容量以及选择性地禁用资源强夺来部分支持优先级，而公平调度器可以通过应用程序和队列两个层面上的权重来实现优先级。
- 对并发应用数量的控制：容量调度器是硬性限制（也可以通过控制分配给应用程序主控的资源来间接实现柔性限制），而公平调度器直接是柔性限制。
- 队列内的资源分配策略：容量调度器是FIFO，而公平调度器支持三种内置的可插拔的策略：FIFO, FAIR, 和DRF。

## 总结

总体来说，容量调度器和公平调度器的相似多过区别。个人感觉，两者的区别主要是实现上的区别以及参数配置上的区别（运行时的性能和表现肯定也有区别）。公平调度器对优先级以及并发度的控制比容器调度器更直观。另外，本人猜测，[容器调度器由HortonWorks主导](https://hortonworks.com/blog/yarn-capacity-scheduler/)，而[公平调度器由cloudera主导](https://blog.cloudera.com/blog/2016/01/untangling-apache-hadoop-yarn-part-3/)。

最后一点小提示：调度器可以用terasort这样的MapReduce程序来进行简单测试。比如：

```
# 生成100GB的输入
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen 1073741824 /tmp/teraInput

# 生成20个应用程序，并放入myqueue队列里
for i in $(seq -w 00 19); do
    nohup hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar terasort -Dmapreduce.job.queuename=myqueue /tmp/teraInput /tmp/teraOutput-$i &> $i.log &
    sleep 1;
done
```

## 参考文档

- 容量调度器: [capacity scheduler](https://hadoop.apache.org/docs/r2.7.3/hadoop-yarn/hadoop-yarn-site/CapacityScheduler.html)
- 公平调度器: [fair scheduler](https://hadoop.apache.org/docs/r2.7.3/hadoop-yarn/hadoop-yarn-site/FairScheduler.html)

![hadoop-logo](https://user-images.githubusercontent.com/15970333/102699853-874d4a00-4248-11eb-8d50-302b5ebc7b57.jpg "Apache Hadoop logo")
