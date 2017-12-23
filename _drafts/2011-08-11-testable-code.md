---
layout: post
title:  "Testable code"
date:   2011-08-11 17:04:00 +0000
category: post
tags: [Software Engineering]
---

I know quite many developers who enjoy coding, but hate testing. I guess these are the possible reasons:

1. Testing is actually more difficult than coding!

    Coding is easy, testing is harder. Testing badly designed code is even harder. Some code (especially some legacy code) is simply impossible to test (without refactoring and risking of breaking stuff which has been somehow working).

2. Developers often do not consider testing as a part of coding

    In fact, testing, especially writing unit tests, shall be definitely the responsibility of developers, instead of the QA team (Update on 2017-11-07: it is now trendy to integrate QA engineers into the development teams, which makes the entire development team solely responsible for writing all tests, including unit tests, regression tests, and integration tests.).

Testable code makes testing easier and it is developers responsibility to make the code testable, just as to make the code clean. In fact, testable code is often clean code at the same time.

The following _principles_ are my summarized notes from reading [Misko Hevery's post on writing testable code](http://misko.hevery.com/code-reviewers-guide/)

1. Keep constructors simple, don't create objects of direct dependencies, but pass them in (after creating them using factories or builders)!

2. Seeing more than one period "." in a method chaining where the methods are getters (e.g., `a.getB().getC().doStuff()`) is a sign of a Law of Demeter (LoD, or principle of least knowledge) violation.

3. Global state (static fields) and Singleton (the hidden global state) are harmful, at least from a testing point of view (e.g., making the order of testing significant). They also introduce (hidden) dependencies and make APIs lie about their true dependencies.