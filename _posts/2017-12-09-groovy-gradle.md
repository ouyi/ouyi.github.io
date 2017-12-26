---
layout: post
title:  "Understanding Gradle DSL"
date:   2017-12-09 19:25:13 +0000
last_modified_at: 2017-12-25 20:05:09
category: post
tags: [Groovy, Gradle, CI/CD]
---

**Contents**
* TOC
{:toc}
Most of the time, Gradle works just fine for me, but I had difficulties
understanding the build script and the Gradle DSL documentation. This post
documents the points which helped me to understand them.

## Groovy basics 
To understand Gradle, we first need to understand a bit of Groovy, because Gradle is based on Groovy.

### Closure

A closure is a function bound to (or executed against) some object instances,
which can be one of these three things: this, owner, and delegate.

- this: the instance of the enclosing class
- owner: same as this, or the enclosing closure if exists
- delegate: same as owner, but can be changed

By default, a variable accessed in a Groovy closures is resolved as follows:
the closure itself will be checked first, followed by the closure's this scope,
then the closure's owner, then its delegate.

The following example demostrate changing the delegate of a closure:

{% highlight groovy %}
class MyOtherClass {
    String myString = "I am over in here in MyOtherClass"
}

class MyClass {
    def myClosure = {
        println myString
    }
}

MyClass myClass = new MyClass()
def closure = new MyClass().myClosure
closure.delegate = new MyOtherClass() // Change the delegate makes variables in the new delegate available to the closure
closure()   // outputs: "I am over in here in MyOtherClass"
{% endhighlight %}

It is important to notice that closure can access member fields and methods defined in another object, which can be changed dynamically at runtime.
As a side note: closure and lambda are different concepts. A lambda is simply an anonymous function, without all the this, owner, and delegate stuff.

### Method calls

Method calls in Groovy look quite different than in Java. The following are all method call examples in Groovy:

{% highlight groovy %}

println x // System.out is imported by default, no parenthesis needed if there is at least one parameter

println 1..3 // prints the sequence 1, 2, and 3

printArgs x, a:1, b:2 // named parameters are collected and passed as a map, if the first parameter of the method is a map

doStuff { println it } // closure as the method parameter, `it` is the default closure parameter

list.each { println it } // for each of the list items, execute the closure, with the item as parameter

list.each { i -> println i } // same as above, the closure parameter can also be specified explicitly

repositories() { println "in a closure" } // call the repositories() method defined on the project object

repositories { println "in a closure" } // same as above, no parenthesis needed

{% endhighlight %}

In contrast to the last example, the following is a method definition:

{% highlight groovy %}
void repositories() { println "in a closure" }
{% endhighlight %}

## Gradle basics

Note in Gradle DSL, closures are frequently (and idiomatically) used as the
last method parameter to configure some object. This is a pattern called
[configuration closure](https://docs.gradle.org/current/userguide/writing_build_scripts.html#groovy-dsl-basics).

>Each closure has a delegate object, which Groovy uses to look up variable and
method references which are not local variables or parameters of the closure.
Gradle uses this for configuration closures, where the delegate object is set
to the object to be configured.

Gradle processes a build script in three phases: initialization, configuration,
and execution. The initialization and configuration phases create and configure
project objects and construct a DAG of tasks, which are then executed in the
execution phase. 

### Dependencies

With the above being discussed, I understand the following is calling the `dependencies()` method on the project object.
And the documentation indicates the configuration closure is executed against the DependencyHandler object.

{% highlight groovy %}
dependencies {
    testCompile group: 'junit', name: 'junit', version: '4.12'
}
{% endhighlight %}

But where is `testCompile` defined?

The [DependencyHandler documentation](https://docs.gradle.org/current/javadoc/org/gradle/api/artifacts/dsl/DependencyHandler.html) says:

>To declare a specific dependency for a configuration you can use the following syntax:
> 
>     dependencies {
>         configurationName dependencyNotation1, dependencyNotation2, ...
>     }

So `testCompile` is a `configurationName`, but where is this configurationName defined? It turns out that Gradle plugins can add various stuff to the project.
In our case, the `testCompile` is a [dependency configuration added by the java plugin](https://docs.gradle.org/current/userguide/java_plugin.html#sec:java_plugin_and_dependency_management). That is why we need this line in our build script:

{% highlight groovy %}
apply plugin: 'java' //so that we can use 'compile', 'testCompile' for dependencies
{% endhighlight %}

### Tasks

Gradle plugins can also add tasks to the project, e.g., the [jar task added by the java plugin](https://docs.gradle.org/current/userguide/java_plugin.html#sec:jar):

{% highlight groovy %}
jar {
  manifest {
    attributes(
      'Class-Path': configurations.compile.collect { it.getName() }.join(' '),
      'Main-Class': 'hello.HelloWorld'
    )
  }
}
{% endhighlight %}

The documentation says:

>Each jar or war object has a `manifest` property with a separate instance of Manifest.

This explains the `manifest {}` construct. Following the [documentation of
Manifest](https://docs.gradle.org/current/javadoc/org/gradle/api/java/archives/Manifest.html),
we can find the method signature `Manifest attributes(Map<String,?>
attributes)`, which explains the method call with named parameters
`attributes(key1:value1, key2:value2)`.

### Custom tasks

The syntax of a custom task is tricky. For example:

{% highlight groovy %}
task myTask(type:Tar, dependsOn anotherTask) {
    // clousre
}
{% endhighlight %}

I could figure out that this was probably calling the method `Task
task(Map<String,?> args, String name, Closure configureClosure)` [defined on
the project object](https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html#task(java.util.Map,%20java.lang.String,%20groovy.lang.Closure)),
but I had no clue how to match the `myTask()` construct with the `name`
parameter. And I am not alone, similar disussions are
[here](https://discuss.gradle.org/t/how-to-translate-task-keyword-in-dsl-into-groovy-call/7243)
and
[here](https://stackoverflow.com/questions/27584463/understanding-the-groovy-syntax-in-a-gradle-task-definition).

It turns out that Gradle uses some advanced meta programming features of Groovy
(compile-time metaprogramming) to transform the `myTask()` construct to the
`name` parameter. To be honest, this is the part of Gradle that I do not like
because it seems to be too tricky to implement those syntax sugars (and too
much sugar may not be healthy). Afterall, Gradle is just a build tool, which
shall be easy to understand, to use, and to extend. Overall I find Gradle
really cool, because I think having humans writing XML files (as with Maven or
Spring) is a terrible idea, which are supposed to be processed by machines :wink:.
