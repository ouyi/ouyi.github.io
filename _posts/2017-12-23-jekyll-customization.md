---
layout: post
title:  "Customizing Jekyll theme"
date:   2017-12-23 07:56:11 +0000
category: post
tags: [Blogging, Jekyll]
---

**Contents**
* TOC
{:toc}
While Jekyll supports a lot of themes which work quite well out of the box, it
allows customizations of almost everything of the site. A theme is a
pre-defined set of styles, templates, and template variables. My site is based
on the default Jekyll theme: [minima](https://github.com/jekyll/minima). The
command `bundle show minima` can be used to find the location where the theme
artifacts are installed, e.g.:

```
[ouyi.github.io]$ tree $(bundle show minima)
/home/ouyi/ouyi.github.io/.bundle/gems/minima-2.1.1
|-- LICENSE.txt
|-- README.md
|-- _includes
|   |-- disqus_comments.html
|   |-- footer.html
|   |-- google-analytics.html
|   |-- head.html
|   |-- header.html
|   |-- icon-github.html
|   |-- icon-github.svg
|   |-- icon-twitter.html
|   `-- icon-twitter.svg
|-- _layouts
|   |-- default.html
|   |-- home.html
|   |-- page.html
|   `-- post.html
|-- _sass
|   |-- minima
|   |   |-- _base.scss
|   |   |-- _layout.scss
|   |   `-- _syntax-highlighting.scss
|   `-- minima.scss
`-- assets
    `-- main.scss

5 directories, 20 files
```

To override the theme defaults, simply copy the related file from the theme
installation location to your project, under the same folder. For example, the
following customization adds feed link in the header:

```
[ouyi.github.io]$ diff .bundle/gems/minima-2.1.1/_includes/header.html _includes/header.html
27a28
>           <a class="page-link" href="{{ "/feed.xml" | relative_url }}"><i class="fa fa-rss" aria-hidden="true"></i></a>
```

As another example, to include custom styles, make a copy of the main.scss file
and add lines to import from any custom style sheets.

```
[ouyi.github.io]$ diff .bundle/gems/minima-2.1.1/assets/main.scss assets/main.scss
5a6
> @import "custom";
[ouyi.github.io]$ ls _sass/
custom.scss
```

By default, bundler installs gems in a central location shared by all ruby
projects. To change that, set `BUNDLE_DISABLE_SHARED_GEMS` to true in the
bundler config file, e.g.:

```
cat .bundle/config
---
BUNDLE_DISABLE_SHARED_GEMS: "true"
```

## Pagination of the home page

By default, the minima's home page shows the complete list of posts, which is
not nice. What I would prefer are:

1. split the home page into multiple pages, if that list become long
2. control the number of posts displayed per page
3. link from each page to the previous and next pages

It turns out that Jekyll already has some support for
[pagination](https://jekyllrb.com/docs/pagination/). To enable it, one has to
add a line to the `_config.yml` file, specifying the number of items per page,
e.g.: `paginator: 8`. With pagination enabled, Jekyll populates a `paginator`
liquid object.

The following diff shows my changes to the default home layout, demonstrating
the use of the paginator object:

{% highlight liquid %}
{% raw %}
[ouyi.github.io]$ diff .bundle/gems/minima-2.1.1/_layouts/home.html _layouts/home.html
7,8c7,8
<   <h1 class="page-heading">Posts</h1>
<
---
>   <h1 class="post-title">Posts</h1>
>
12c12
<     {% for post in site.posts %}
---
>     {% for post in paginator.posts %}
19a20
>         {{ post.excerpt | strip_html | replace_first: 'Contents', '' | lstrip | truncatewords: 40, "" }}<a href="{{ post.url | relative_url }}">&hellip; read more &raquo;</a>
24,25c25
<   <p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | relative_url }}">via RSS</a></p>
<
---
>   {% include prev_next.html prev_url=paginator.previous_page_path prev_text='Previous page' next_url=paginator.next_page_path next_text='Next page' %}
{% endraw %}
{% endhighlight %}
<!--_-->

Basically, instead of iterating over `site.posts`, one has to loop over
`paginator.posts`. In addition, pagination only works with the index.html file, which references the
home layout. I also had to rename the file index.md (default) to
index.html to fix this error:

```
Pagination: Pagination is enabled, but I couldn't find an index.html page to use as the pagination template. Skipping pagination.
```

## Links to the previous and next pages

The links to the previous and next pages are implemented as a macro in the
[prev_next.html
file](https://github.com/ouyi/ouyi.github.io/blob/master/_includes/prev_next.html).
The macro requires four named parameters: `prev_url`, `prev_text`, `next_url`,
and `next_text`. This line includes the macro and passes the required
parameters:

{% highlight liquid %}
{% raw %}
{% include prev_next.html prev_url=paginator.previous_page_path prev_text='Previous page' next_url=paginator.next_page_path next_text='Next page' %}
{% endraw %}
{% endhighlight %}

The same macro is reused by the [post layout](https://github.com/ouyi/ouyi.github.io/blob/master/_layouts/post.html) to render the links to the previous and next _posts_.

## Render table of contents

Rendering of table of contents (TOC) is supported by kramdown. Adding the following code snippet
directly after the front matter will do the trick:

```
---
My front matter
---

**Contents**
* TOC
{:toc}
My first paragraph.
```

The rendered TOC will have a bold section header "Contents", which is nice, but
it becomes a part of the `post.excerpt` variable, which is not so nice.

The `post.excerpt` variable is used in the home layout (see also the previous
section), to show an excerpt of the post content for each post, in addition to
its post title. That way the post content can be previewed on the home page(s),
before a reader decides to click the `read more` button which links to the
complete post content. Therefore, I had to cut of the extra `Contents` string as follows:

{% highlight liquid %}
{% raw %}
{{ post.excerpt | strip_html | replace_first: 'Contents', '' | lstrip | truncatewords: 40, "" }}<a href="{{ post.url | relative_url }}">&hellip; read more &raquo;</a>
{% endraw %}
{% endhighlight %}

Another caveat is that no empty lines shall be present between the `{:toc}` tag
and the first paragraph, or else the latter will be not included in the
`post.excerpt` variable.

## Categories and tags

Categories and tags are two largely overlapping concepts in Jekyll. From a
product perspective, I doubt the necessity of having both implemented, which do
not provide added value instead of confusing the users. The only difference
seems to be that categories become a part of the post URL. That means, a post
having the `category: hadoop` in the front matter would have a URL like
`https://ouyi.github.io/hadoop/2017/10/08/hbase.html`, where `hadoop` is the
category. That also means, posts published on the same date (or in the same
month or year) will be put into different folders, if they are of different
categories. I do not like that. One could also customize the permalink pattern
in Jekyll to remove the categories from the URL. But I chose to set the
categories of all posts to `post`, e.g.:

```
ouyi.github.io]$ head -7 _posts/2017-12-19-java-mail.md
---
layout: post
title:  "Sending emails from Java applications"
date:   2017-12-19 22:12:13 +0000
category: post
tags: [Java, Spring]
---
```

This way all posts go to the post category, which is simple and clear. The tags
are used to generate a [tags page](/tags/), where all the posts are indexed by
tags. The page generation code can be found
[here](https://github.com/ouyi/ouyi.github.io/blob/master/tags.html).
