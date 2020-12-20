---
layout: post
title:  "Null gotchas in Apache Pig"
date:   2018-09-01 15:23:07 +0000
last_modified_at: 2018-10-05 19:45:21
category: post
mathjax: true
tags: [Big Data]
---

* TOC
{:toc}
Apache Pig's **concept of null** was not straight forward to me, although it is clearly documented in the [Pig book](#gates) and highlighted in one of its early chapters:

>It is important to understand that in Pig the concept of null is the same as in SQL, which is completely different from the concept of null in C, Java, Python, etc. <cite>-- [Gates, A. and Dai, D., 2016](#gates), p. 26</cite>

I missed to read this and had some fun :wink: investigating a production issue related to nulls. For people like me who do not read (tech) books front to back, it is easier to have all the pieces of information related to a topic together in one place. Therefore the following is a collection of important points on the concept of null from the book, together with some simple experiments.

## Boolean operators and filters

>For Boolean operators, nulls follow the SQL ternary logic. Thus, `x == null` results in a value of `null`, not `true` (even when `x` _is also_ `null`) or `false`. Filters pass through only those values that are `true`. <cite>-- [Gates, A. and Dai, D., 2016](#gates), pp. 54-55</cite>

In Apache Pig, Boolean expressions with nulls can yield [three possible values](https://en.wikipedia.org/wiki/Three-valued_logic): `true`, `false`, and `null`. This is not always obvious and **can cause confusion**, because people would expect a Boolean operator to return either `true` or `false`, as it does in some other programming languages, e.g., Python or Java.

When I first saw the following code:

```pig
A = load 'input.txt' as (k:int, v:int);
B = filter A by k == 1;
C = filter A by k != 1;
```

I naively believed that the union of `B` and `C` is equivalent to `A`, following the [Complement Laws](https://en.wikipedia.org/wiki/Complement_(set_theory)#Properties), which says the union of a set $S$ and its absolute complement $S^\complement$ is the universe $U$, i.e.,

$$ S \cup S^\complement = U.$$

The problem is that in our example, `C` is not `B`'s absolute complement, due to the nulls, i.e.,

$$B^\complement = C \cup \text{\{records whose k field is null\}}$$

$$\Longrightarrow$$ 

$$ A = B \cup B^\complement = B \cup C \cup \text{\{records whose k field is null\}}.$$ 

So the Complement Laws still apply. We just need to keep in mind that the absolute complement of `filter A by condition` is `filter A by not condition` **plus** the records whose k field `is null`. This can be demonstrated by the following experiments.

First, lets prepare an input file, which contains a record with a null field:
```
cat > input1.txt
1,X
,Y
3,Z
CTRL+D
```

Then, we can run the following Pig commands and examine the dumped values:

```pig
A = load 'input1.txt' using PigStorage(',') as (k:int, v:chararray);

B = filter A by k == 1;
dump B;
-- (1,X)

C = filter A by k != 1;
dump C;
-- (3,Z)

D = filter A by k is null;
dump D;
-- (,Y)

U = union B, C, D;
dump U;
-- (1,X)
-- (,Y)
-- (3,Z)
```

Note that the record `(,Y)` passes **neither** the filter `k == 1` **nor** the filter `k != 1`. It only qualifies for the filter `k is null`. Therefore, only the union of `B`, `C`, and `D` can be equivalent to `A`.

## Regular expressions

>Likewise, `null` neither matches nor fails to match any regular expression value. <cite>-- [Gates, A. and Dai, D., 2016](#gates), pp. 54-55</cite>

Again, lets first prepare an input file, which contains a record with a null field:
```
cat > input2.txt
a,X
,Y
c,Z
CTRL+D
```

Then, we can run the following Pig commands and examine the dumped values:

```pig
A = load 'input2.txt' using PigStorage(',') as (k:chararray, v:chararray);

B = filter A by k matches 'a';
dump B;
-- (a,X)

C = filter A by not (k matches 'a');
dump C;
-- (c,Z)

D = filter A by k is null;
dump D;
-- (,Y)

U = union B, C, D;
dump U;
-- (a,X)
-- (,Y)
-- (c,Z)
```

## Null values are viral

>Null values are viral for all arithmetic operators. That is, `x + null == null` for all values of x.

>Pig also provides a binary condition operator, often referred to as `bincond`. It begins with a Boolean test, followed by a `?`, then the value to return if the test is true, then a `:`, and finally the value to return if the test is false. If the test returns `null`, bincond returns `null`. <cite>-- [Gates, A. and Dai, D., 2016](#gates), p. 48</cite>

This can be verified with the following tests:

```pig
A = load 'input1.txt' using PigStorage(',') as (k:int, v:chararray);
dump A;
-- (1,X)
-- (,Y)
-- (3,Z)

B = foreach A generate k + 1, v;
dump B;
-- (2,X)
-- (,Y)
-- (4,Z)

C = foreach A generate (k == null ? 2 : k), v;
-- (,X)
-- (,Y)
-- (,Z)

D = foreach A generate (k is null ? 2 : k), v;
-- (1,X)
-- (2,Y)
-- (3,Z)
```

Note the different bincond (ternary operator) expressions used to generate `C` and `D`, and `k == null` always resulted in nulls, whereas `k is null` delivered the intended results (`true` or `false`).

## Grouping and joining nulls

>Finally, group handles nulls in the same way that SQL handles them: by collecting all records with a null key into the same group. <cite>-- [Gates, A. and Dai, D., 2016](#gates), p. 44</cite>

```pig
A = load 'input3.txt' using PigStorage(',') as (k:int, v:chararray);
dump A;
-- (1,X)
-- (,Y)
-- (3,Z)
-- (,G)

B = group A by k;
dump B;
-- (1,{(1,X)})
-- (3,{(3,Z)})
-- (,{(,G),(,Y)})
```

>As in SQL, null values for keys do not match anything, even null values from the other input. So, for inner joins, all records with null key values are dropped. For outer joins, they will be retained but will not match any records from the other input. <cite>-- [Gates, A. and Dai, D., 2016](#gates), p. 47</cite>

```pig
A = load 'input3.txt' using PigStorage(',') as (k:int, v:chararray);
B = load 'input3.txt' using PigStorage(',') as (k:int, v:chararray);

C = join A by k, B by k;
dump C;
-- (1,X,1,X)
-- (3,Z,3,Z)

D = join A by k full outer, B by k;
dump D;
-- (1,X,1,X)
-- (3,Z,3,Z)
-- (,G,,)
-- (,Y,,)
-- (,,,G)
-- (,,,Y)
```

Note grouping treats nulls as identical values, whereas joining treats nulls as different (by not matching them).

## Summary

In a nut shell, nulls in Apache Pig:
- can be produced by Boolean expressions
- are viral for all arithmetic operators
- yields nulls in equality checks (unless `is null` is used for the check)
- yields nulls in regex match checks
- are treated as identical values for grouping, and
- are treated as different values for joining

## References

<a name="gates"></a>Gates, A. and Dai, D., 2016. Programming pig: Dataflow scripting with hadoop. "O'Reilly Media, Inc.".

![pig-logo](https://user-images.githubusercontent.com/15970333/102699855-8a483a80-4248-11eb-89c7-e228e4dd30f4.gif "Apache Pig logo")
