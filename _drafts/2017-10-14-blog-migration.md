---
layout: post
title:  "Migrating from Blogspot to Github Pages"
date:   2017-10-14 07:56:11 +0000
category: post
tags: [Blogging]
---

## pagination

```
Pagination: Pagination is enabled, but I couldn't find an index.html page to use as the pagination template. Skipping pagination.
```

blogger.com => Theme => Edit HTML 

```
    <b:if cond='data:blog.url == &quot;https://ouyi-cs.blogspot.com/2015/12/hadoop-streaming-broken-pipe-issue.html&quot;'>
    <link rel='canonical' href='https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html'/>
    <meta http-equiv='refresh' content='0; url=https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html'/>
    </b:if>
```

http and https

blogspot templating language vs. Jekyll and liquid

google and bing indexing speed

categories and tags: category => post, tags => tags page (indexing by tags)

```
cat .bundle/config
---
BUNDLE_DISABLE_SHARED_GEMS: "true"
```

customize minima css
    [not working](https://help.github.com/articles/customizing-css-and-html-in-your-jekyll-theme/)

working:
    [minima doc](https://github.com/jekyll/minima)

    cat _sass/minima.scss
    ...
    // Import partials.
    @import
      "minima/base",
      "minima/layout",
      "minima/syntax-highlighting",
      "custom"
    ;

[Create "read more" links](http://www.seanbuscay.com/blog/jekyll-teaser-pager-and-read-more/)

[Links to prev and next posts](http://david.elbe.me/jekyll/2015/06/20/how-to-link-to-next-and-previous-post-with-jekyll.html)

[Move a site with URL changes](https://support.google.com/webmasters/answer/6033049)

[Handling legitimate cross-domain content duplication](https://webmasters.googleblog.com/2009/12/handling-legitimate-cross-domain.html)

[Widget Tags for Layouts](https://support.google.com/blogger/answer/46995?hl=en&ref_topic=6321969)

[301 redirect for specific post in Blogger blog?](https://webapps.stackexchange.com/questions/6140/301-redirect-for-specific-post-in-blogger-blog)

[Host images](https://stackoverflow.com/questions/18360714/official-image-host-for-github-projects)

[Travis CI](https://github.com/ouyi/ouyi.github.io/blob/master/.travis.yml)
