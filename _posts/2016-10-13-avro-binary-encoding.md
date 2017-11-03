---
layout: post
title:  "A short introduction to Avro binary encoding"
date:   2016-10-13 18:50:42 +0000
category: post
tags: [Avro]
---

When developing applications processing Avro data, a basic understanding of Avro schema and Avro binary encoding is helpful.
I disscussed a [small topic on Avro schema here]({{ site.baseurl }}{% post_url 2016-02-08-avro-schema %}).
The focus of this post is [Avro binary encoding](https://avro.apache.org/docs/1.7.7/spec.html#binary_encoding).

## Avro file structure

The structure of a binary Avro file can be described with the following informal production rules:

```
Avro file := header + block 1 [+ ... + block n]
header := 'Obj1' (4 B) + metadata + sync marker (16 B)
block := object count (long) + objects byte size after compression (long) + serialized objects + sync marker (16 B)
object := field 1 + [+ ... + field n]
field := (length or structural info if needed) + binary encoded field value
```

The above rules translated in plain English are:

* An Avro _file_ consists of a _header_ and `n` _blocks_.

* The _header_ consists of the string literal `Obj1`, _metadata_, and a _sync marker_. The _metadata_ are persisted as key-value pairs. The most important ones among them are the schema and the compression codec (with the keys `avro.schema` and `avro.codec`).

* A _block_ starts with information about the number of objects it contains, followed by the total size of those objects in bytes after compression, then by the serialized objects, and finally ends with the sync marker. The _sync marker_ has two major purposes:
    - It enables detection of corrupt blocks and help ensure data integrity.
    - It permits efficient splitting of files for [MapReduce processing](https://avro.apache.org/docs/1.7.7/mr.html).

* An _object_ is serialized as the sequence of its fields in binary form.

* A _field's binary form_ consists of the field length or structural information, which is optional and present only if it can not be derived from the schema, and the binary encoded field value.

## Example

Lets say we have the following simple Avro schema stored in a file `Person.avsc`:

{% highlight json %}
{
    "type":"record",
    "name":"Person",
    "fields":[
        {
            "name":"name",
            "type":"string"
        }
    ]
}
{% endhighlight %}

And some data of this schema in JSON format stored in a file `person.json`:

{% highlight json %}
{"name":"John"}
{"name":"Alice"}
{% endhighlight %}

The data can be converted from JSON to Avro binary file with avro-tools like this:

{% highlight bash %}
$ wget http://repo1.maven.org/maven2/org/apache/avro/avro-tools/1.7.7/avro-tools-1.7.7.jar
$ java -jar avro-tools-1.7.7.jar fromjson --schema-file Person.avsc person.json > person.avro
{% endhighlight %}

On Linux, the Avro binary file can be viewed with `xxd`:

```
$ xxd person.avro
0000000: 4f62 6a01 0416 6176 726f 2e73 6368 656d  Obj...avro.schem
0000010: 6198 017b 2274 7970 6522 3a22 7265 636f  a..{"type":"reco
0000020: 7264 222c 226e 616d 6522 3a22 5065 7273  rd","name":"Pers
0000030: 6f6e 222c 2266 6965 6c64 7322 3a5b 7b22  on","fields":[{"
0000040: 6e61 6d65 223a 226e 616d 6522 2c22 7479  name":"name","ty
0000050: 7065 223a 2273 7472 696e 6722 7d5d 7d14  pe":"string"}]}.
0000060: 6176 726f 2e63 6f64 6563 086e 756c 6c00  avro.codec.null.
0000070: fa4b c7d2 52a1 aa57 92cb cdfd 20d8 c341  .K..R..W.... ..A
0000080: 0416 084a 6f68 6e0a 416c 6963 65fa 4bc7  ...John.Alice.K.
0000090: d252 a1aa 5792 cbcd fd20 d8c3 41         .R..W.... ..A
```

The string area on the right-hand side reveals two key-value pairs with keys being `avro.schema` and `avro.codec`.
