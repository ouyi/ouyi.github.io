---
layout: post
title:  "Parameterized IN clause with JDBI and PostgreSQL"
date:   2017-06-02 08:28:07 +0000
category: java
tags: [JDBI, PostgreSQL]
---

## The problem

I was hoping the following code snipet would work with JDBI. It truns out to be not working.

{% highlight java %}
try (Handle handle = dbi.open()) {
    return handle.createQuery("SELECT COUNT(1) FROM company WHERE name IN ( :company_names )");
            .bind("company_names", new String[]{"aol", "msft", "yahoo"})
            .map(IntegerColumnMapper.PRIMITIVE)
            .first();
}
{% endhighlight %}

## The solution

The reason, I guess, is that the array type is not equivalent to a table
expression, which is conceptually a set. Furthermore, for the JDBI array
binding to work, the parameter value to be bound needs to be of the type
`java.sql.Array`. Therefore, the following code works.

{% highlight java %}
try (Handle handle = dbi.open()) {
    return handle.createQuery("SELECT COUNT(1) FROM company WHERE name IN (SELECT * FROM UNNEST(:company_names))");
            .bind("company_names", handle.getConnection().createArrayOf("text", new String[]{"aol", "msft", "yahoo"}))
            .map(IntegerColumnMapper.PRIMITIVE)
            .first();
}
{% endhighlight %}

Note the `SELECT * FROM UNNEST(:company_names)` part to convert the sql array
passed in into a table expression, and the
`handle.getConnection().createArrayOf("text", new String[]{"aol", "msft", "yahoo"})`
part to convert a normal Java array into a `java.sql.Array` of `text` type.

As an alternative, this also works:

{% highlight java %}
try (Handle handle = dbi.open()) {
    return handle.createQuery("SELECT COUNT(1) FROM company WHERE ARRAY[name] && :company_names");
            .bind("company_names", handle.getConnection().createArrayOf("text", new String[]{"aol", "msft", "yahoo"}))
            .map(IntegerColumnMapper.PRIMITIVE)
            .first();
}
{% endhighlight %}

The `ARRAY[name]` part converts the `name` column value into an array with a
single element, and then tests for intersection with the array passed in as a
parameter.

The above workarounds only work for PostgreSQL. A more generic (and complex)
solution would be to generate the sql string dynamically (e.g., using a
template engine), then bind the array elements one by one in a loop.

## References

- [Discussions on stackoverflow](https://stackoverflow.com/a/32748142)
- [Article by the author of JDBI](https://skife.org/jdbi/java/2011/12/21/jdbi_in_clauses.html)

[//]: # ( https://stackoverflow.com/questions/3107044/preparedstatement-with-list-of-parameters-in-a-in-clause )
[//]: # ( http://farrago.sourceforge.net/design/CollectionTypes.html )
