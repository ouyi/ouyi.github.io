---
layout: post
title:  "Migrating from Blogspot to Github Pages"
date:   2017-10-14 07:56:11 +0000
category: Misc
tags: [blogging]
---

blogger.com => Theme => Edit HTML 

```
    <b:if cond='data:blog.url == &quot;https://ouyi-cs.blogspot.com/2015/12/hadoop-streaming-broken-pipe-issue.html&quot;'>
    <link rel='canonical' href='https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html'/>
    <meta http-equiv='refresh' content='0; url=https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html'/>
    </b:if>
```

[Move a site with URL changes](https://support.google.com/webmasters/answer/6033049)

[Handling legitimate cross-domain content duplication](https://webmasters.googleblog.com/2009/12/handling-legitimate-cross-domain.html)

[Widget Tags for Layouts](https://support.google.com/blogger/answer/46995?hl=en&ref_topic=6321969)

[301 redirect for specific post in Blogger blog?](https://webapps.stackexchange.com/questions/6140/301-redirect-for-specific-post-in-blogger-blog)

[Host images](https://stackoverflow.com/questions/18360714/official-image-host-for-github-projects)

[Travis CI](https://github.com/ouyi/ouyi.github.io/blob/master/.travis.yml)
