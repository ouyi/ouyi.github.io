---
layout: post
title:  "Understanding JavaScript Prototype"
date:   2016-09-28 17:01:14 +0000
last_modified_at: 2017-12-25 20:12:15
category: post
tags: [JavaScript]
---

* TOC
{:toc}
This shall be a 10-minute read on the JavaScript prototype topic. It is my
notes when reading Angus Croll's [post on the same topic](https://javascriptweblog.wordpress.com/2010/06/07/understanding-javascript-prototypes/).
All the code examples here can be easily verified using nodejs or browser
developer tools, e.g., that of Chrome. Feel free to let me know if there
is anything mistaken.

## Object and function

An object in JavaScript is an unordered collection of key-value pairs. If it's
not a primitive (undefined, null, boolean, number or string), it's an object. A
function is also an object.

Note in the following the difference between term _prototype_ and the term
_prototype property_. The former is used in an object context, whereas the
latter in a function context.

## Object prototype

Create an object:

{% highlight javascript %}
var a = {};
{% endhighlight%}

The following do not work, because only a function has the prototype property:

{% highlight javascript %}
({}).prototype // undefined
a.prototype // undefined
{% endhighlight%}

The true prototype of an object is held by an _internal property_, which can be
accessed in the following ways:

{% highlight javascript %}
Object.getPrototypeOf(a); // ECMA 5
a.__proto__; // all browsers except IE
{% endhighlight%}

Most of the time, an object's prototype is the prototype property of its
constructor (which is a function). The following works on all browsers, but
only if constructor.prototype has not been replaced.

{% highlight javascript %}
a.constructor.prototype;
{% endhighlight%}

When a primitive is asked for it's prototype it will be coerced to an object.

{% highlight javascript %}
false.__proto__ === Boolean(false).__proto__; // true
{% endhighlight%}

Using prototype for inheritance (note Array is the array constructor):

{% highlight javascript %}
a.__proto__ = Array.prototype;
a.length; // 0, because a "is" now an Array
{% endhighlight%}

## Function prototype property

A function's prototype property is the object that will be assigned as the
prototype to all instances created using this function as a constructor. That
object is the prototype for all those instances.

Every function gets a prototype property (built-in function excepted), i.e., it
can be accessed using the `.prototype` syntax. Anything that is not a function
does not have such a property.

{% highlight javascript %}
var A = function() {};
var a = new A(); // using A as a's constructor
a.__proto__ === A.prototype; // true
A.prototype.constructor == A; // true
a.constructor == A; // true
{% endhighlight%}

Note the above `a`'s constructor property is inherited from it's prototype.
More on that in [the next section](#prototype-chain-and-prototypical-inheritance).

This function will never be a constructor but it also has a prototype property:

{% highlight javascript %}
(new Function()).prototype;
{% endhighlight%}

Math is not a function so no prototype property:

{% highlight javascript %}
Math.prototype; // undefined
{% endhighlight%}

A function (object)'s prototype is not the same as it's prototype property

{% highlight javascript %}
A.__proto__ != A.prototype; // true
{% endhighlight%}

A's prototype is set to its constructor's prototype property (Function is the constructor for all function objects):

{% highlight javascript %}
A.__proto__ == Function.prototype; // true
{% endhighlight%}

## Prototype chain and prototypical inheritance<a name="prototype-chain-and-prototypical-inheritance"></a>

When object `a` is asked to evaluate property `foo`, JavaScript walks the
prototype chain (starting with object a itself), checking each link in the
chain for the presence of property foo. If and when foo is found, it is
returned, otherwise, `undefined` is returned.

Prototypical inheritance is not a player when property values are set. `a.foo =
'bar'` will always be assigned directly to the `foo` property of `a`.

The expression `a instanceof A` will return true if `A`'s prototype property occurs in `a`'s prototype chain.

{% highlight javascript %}
a.__proto__ === A.prototype; // true
a instanceof A; // true
a.__proto__ != Function.prototype; // true
a instanceof Function; // false
{% endhighlight%}

Mess around with a's prototype, so that `a`'s prototype no longer in same prototype chain as A's prototype property:

{% highlight javascript %}
a.__proto__ = Function.prototype;
a instanceof Function; // true
a instanceof A; // false
{% endhighlight%}

## Function augmentation

{% highlight javascript %}
String.prototype.times = function(count) {
    return count < 1 ? '' : new Array(count + 1).join(this);
}

"hello world!".times(2); // "hello world!hello world!"
{% endhighlight%}
