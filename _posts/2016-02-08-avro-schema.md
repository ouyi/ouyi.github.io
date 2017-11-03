---
layout: post
title:  "Avro schema field name and type name differences"
date:   2016-02-08 19:30:33 +0000
category: post
tags: [Avro]
---

Avro schema supports nested record definitions, i.e., definition of a custom record, whose fields are again some other custom records. One of the questions I had while working on an Avro schema was: _why do I have to repeat the name field in a subrecord definition_?

Let's take a look at the "address" part of this sample schema:

{% highlight json %}
{
    "namespace": "io.github.ouyi.avro",
    "fields": [
        {
            "name": "id",
            "type": "int"
        },
        {
            "name": "name",
            "type": "string"
        },
        {
            "name": "address",
            "type": {
                "fields": [
                    {
                        "name": "street",
                        "type": "string"
                    },
                    {
                        "name": "city",
                        "type": "string"
                    }
                ],
                "name": "Address",
                "type": "record"
            }
        }
    ],
    "name": "Company",
    "type": "record"
}
{% endhighlight %}

It turns out that the first `address` is the _field name_ and the second `Address` (note the uppercase "A") is the _type name_.

The difference between a field name and a type name becomes clear when the Avro schema is compiled into Java classes. In our example, "address" is used as the name of a member field in the Company class, and "Address" is used as the class name for the generated Address class.

Our sample schema (Company.avsc) can be compiled to Java classes as follows:

{% highlight bash %}
$ java -jar "$AVRO_TOOLS_JAR" compile schema Company.avsc output 
{% endhighlight %}

The generated classes are:

```
$ tree output/
output/
`-- io
    `-- github
        `-- ouyi
            `-- avro
                |-- Address.java
                `-- Company.java
```

The Company class has a member field "address" of the type "Address":

{% highlight java %}
private io.github.ouyi.avro.Address address;
{% endhighlight %}

Considering the Java coding convention, it makes sense that the first letter of the field name is in lower case ("address"), while the same of the type name is in upper case ("Address").

For completeness, the following are a few JSON records based on our sample schema:

{% highlight json %}
{"id":1,"name":"msft","address": {"street": "MS Redmond Campus", "city": "Redmond"}}
{"id":2,"name":"aol","address": {"street": "770 Broadway", "city": "NY City"}}
{"id":3,"name":"google","address": {"street": "Googleplex", "city": "Mountain View"}}
{% endhighlight %}
 
Note that in contrast to the [Avro binary format]({{ site.baseurl }}{% post_url 2016-10-13-avro-binary-encoding %}), the JSON representation does not carry the schema (type information). Therefore, we only see the lower case field names here.

<script>
    hljs.configure({languages: ['json']});
    hljs.initHighlightingOnLoad();
</script>
