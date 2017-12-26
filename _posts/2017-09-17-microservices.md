---
layout: post
title:  "我对微服务(Microservices)的理解"
date:   2017-09-17 10:27:07 +0000
category: architecture
tags: [Architecture]
lang: zh
ref: microservices
---

软件工程领域隔三差五就会出来一些听起来很虚幻的流行词(buzzwords)。
Microservices和SOA(service-oriented architecture 面向服务的架构)就属于这一类。
SOA比Microservices出来得更早，两个词都跟服务和架构有关，
难道又是换汤不换药(old wine in new bottles)，用来忽悠的？

SOA和Microservices其实都是组件化(componentization)这个朴实的概念与时俱进的产物。
听到组件化，应该不会有人觉得玄乎。它的核心思想其实就是分而治之(divide and conquer)，
即把一个复杂系统拆分成多个没那么复杂的组件，这样每个组件都可以被单独开发，测试，甚至部署。
当然每个组件还要能够与系统中的其它组件协同工作。这就要求每个组件：

- 是实现一定的功能的基本单位 (unit of functionality)
- 有定义明确的接口 (well-defined interface)
- 而且遵守一套既定的规则 (component model)

顺便说一下，我认为模块化(modularization)跟组件化并没有本质上的区别。把复杂系统拆分成多个模块，
再把每个模块拆分成组件，有一定的实际意义。这时候可以把模块理解成由多个组件组成的子系统。

把组件或模块封装成Web Services的架构模式即为SOA。SOA的特点是：

- 服务有自主性 (services are autonomous)
- 服务有明确的边界 (explicit boundary)
- 服务之间可以共享schema和契约，但不共享class (services share schema and contract, not class)

我感觉SOA是一个非常模糊的概念。猜测这个概念的定义者到底是怎么想的，很没劲。但拿SOA的这几个特点跟上面组件的特点
对比，可以发现有一定的相似度。我觉得最重要的区别，就是暗示多个服务可以由不同的编程语言实现，这样就没办法共享类(class)了。
但服务之间可以互相通信，因为它们共享schema和契约。

有这么一个模糊的需要猜测才能理解的概念，实践SOA就有难度了。实现出来的的系统也更容易走样。这也就是为什么后来人们提出
Microservices，并强调它的一些特性，以便更好的指导实践。

Microservices可以看作是SOA的改进版(SOA done right)。它强调这些特性：

- 分散的治理 (decentralized governance)
- 聪明的端点加简单的管道 (smart endpoints and dumb pipes)
- 分散的数据管理 (decentralized data management)
- 基础设施的自动化 (infrastructure automation)
- 容错的设计 (design for failure)
- 便于进化的设计 (evolutionary design)
- 等等

我觉得Microservices强调的这些特性结合了近些年业界的一些最佳实践。比如分散的治理和基础设施的自动化就是DevOps和CI/CD的另一种说法。最后，我个人感觉，不管是组件化，SOA，还是Microservices，如何降低组件或服务之间的耦合(dumb pipes)，让软件易于修改和演绎进化，都是软件设计的艺术。

不理解Microservices的程序猿不是好架构狮:wink:。这里是我对这个概念的理解，有错误欢迎斧正(pull requests :wink:)。参考链接：

- [组件化 (Componentization)](http://blogs.windriver.com/koning/2006/09/components.html)
- [面向服务的架构 (SOA)](https://stackoverflow.com/a/25625813)
- [微服务 (Microservices)](https://martinfowler.com/articles/microservices.html)
