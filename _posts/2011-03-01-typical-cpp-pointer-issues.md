---
layout: post
title:  "Typical pointer issues in C++"
date:   2011-03-01 13:18:00 +0000
category: post
tags: [C++]
---

**Contents**
* TOC
{:toc}
Application run into _errors_ when accessing an unknown/undefined memory location (e.g., dereferencing via uninitialized or deleted pointers). _Memory leaks_ occur when you lose track of a piece of dynamically allocated memory. The following are examples of typical pointer-related issues in C++, which I abbreviate as _UNDO (UNinitialized, Deleted, and Overridden) Pointers_.

## Uninitialized pointer

{% highlight cpp %}
    int *p; // p is an uninitialized pointer 
    *p = 3; // bad!
{% endhighlight%}

A NULL pointer is still uninitialized:

{% highlight cpp %}
    int *p = NULL; //p is still uninitialized
    *p = 3; // bad! 
{% endhighlight%}

## Deleted pointer
 
{% highlight cpp %}
    int *p = new int;
    delete p;
    *p = 5; // bad!
{% endhighlight%}
 
_Dangling pointer_ is a pointer to a location that had been pointed to by another pointer, which has been deleted. I consider dangling pointer a special case of deleted pointer.

{% highlight cpp %}
    int *p, *q;
    p = new int;
    q = p; // p and q point to the same location
    delete q; // now p is a dangling pointer
    *p = 3; // bad!
{% endhighlight%}
 
## Overridden pointers

A pointer `p` points to dynamically allocated memory, and you reassign (overwrite) `p` without first deleting it, that memory will be lost and your code will have a memory leak.

{% highlight cpp %}
    int *p = new int;
    p = NULL; // pointer reassignment without freeing the memory
{% endhighlight%}

## Reference

This post is my learning notes summarized from the tutorial [Learning a New Programming Language: C++ for Java Programmers](http://pages.cs.wisc.edu/~hasti/cs368/CppTutorial/).
