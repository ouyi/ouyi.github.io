---
layout: post
title:  "Migrating from Blogspot to Github Pages"
date:   2017-10-14 07:56:11 +0000
category: post
tags: [Blogging, Jekyll]
---

Recently I migrated [my blog](https://ouyi.github.io) from Blogspot to [Github Pages](https://github.com/ouyi/ouyi.github.io). It took a while, but I am glad I
did it, because blogging with Github Pages is much more enjoyable than with
Blogspot, as long as one is comfortable with Git and Markdown. More specifically,
I like Github Pages because:

1. Everything of the blog is version controlled, including posts, themes, and settings
2. Static site generators (I chose Jekyll) allow customisations of almost everything
3. Markdown produces much cleaner HTML pages than those produced by a WYSIWYG editor

With Blogspot I already had some of my posts in Markdown and in a Git
repository. But to publish a post there, I had to convert the post from Markdown
to HTML with some tools, and then paste the result page into the Blogspot post editor Web UI.

Now with Github Pages and Jekyll, the workflow of blogging is like this:

1. Writing a post in Markdown with any text editor, and
2. Add, commit, and push the changes in Git

Github Pages will automatically run a `jekyll build` to generate the HTML pages,
which usually become online in a couple of seconds after the push.

The migration process, however, was not always straightforward. I took notes so
that it might be helpful for the readers.

## Travis CI

The downside of having Github Pages building everything automatically behind the
scenes is that if there is an issue, e.g., a Markdown syntax error, you would not
even notice it. Therefore, I configured it to be built also automatically on
Travis CI, which requires just a config file (`.travis.yml`) [in the root folder
of the project](https://github.com/ouyi/ouyi.github.io/blob/master/.travis.yml):

{% highlight yml %}
language: ruby
cache: bundler
install:
  - bundle install
script:
  - bundle exec jekyll build --safe
  - bundle exec htmlproofer ./\_site --disable-external
{% endhighlight %}

This instructs Travis to generate the site (stored in the `_site` folder) and run
htmlproofer on it while ignoring the linked external sites. For all this to work,
of course, one has to connect the Github project in Travis CI, which is out of scope
of this post (and Github Pages also works without Travis CI).

When all this has been set up, one got email notifications from Travis
on build failures. One got also a small build passing (or failing) badge:

[![Build Status](https://travis-ci.org/ouyi/ouyi.github.io.svg?branch=master)](https://travis-ci.org/ouyi/ouyi.github.io)

The command htmlproofer is provided by the gem `html-proofer`. In addition, to make sure the build on Travis has the same dependencies as the build on Github, specify `gem 'github-pages', group: :jekyll_plugins` in the [Gemfile](https://github.com/ouyi/ouyi.github.io/blob/master/Gemfile).

## Hosting images

I mentioned earlier: "everything of the blog is version controlled". This does
NOT apply to images, because I do not think including images in a Git repository is a
great idea. But we need to host the images somewhere, e.g., S3, CDN, or any other
hosting services. The solution I chose was found on Statck Overflow. It allows me
to host my images on Github, based on a [secret Github feature](https://stackoverflow.com/a/20959426/8886552).

Once I got the URL to the image, I can add the image using standard Markdown
syntax (i.e., `![alt text](image_url "title text")`) or the HTML `img` tag (yes,
in a Markdown file), e.g.:
{% highlight html %}
<img src="https://user-images.githubusercontent.com/15970333/32409768-84c92cc8-c1b2-11e7-9309-428c99da8cac.png" alt="screen shot 1">
{% endhighlight %}

# Redirects and canonical URL tags

After a post has been migrated, there are two versions of it on the Web: the old
one on Blogspot and the new one on Github. Simply removing the old version would
mean a bad user experience (they might have bookmarked the old version) and would
hurt SEO. Ideally, we would like to:

1. redirect the browser visiting the old version to the new version, and
2. tell search engines that the old version is obsolete and the new version is
the one to index.

After some searches, I came up with this kind of Blogspot template code snippet:

{% highlight xml %}
<head>
    <b:if cond='data:blog.url == &quot;https://ouyi-cs.blogspot.com/2015/12/hadoop-streaming-broken-pipe-issue.html&quot;'>
      <link href='https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html' rel='canonical'/>
      <meta content='0; url=https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html' http-equiv='refresh'/>
    <b:elseif cond='data:blog.url == &quot;http://ouyi-cs.blogspot.com/2015/12/hadoop-streaming-broken-pipe-issue.html&quot;'/>
      <link href='https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html' rel='canonical'/>
      <meta content='0; url=https://ouyi.github.io/hadoop/2015/12/06/hadoop-streaming.html' http-equiv='refresh'/>

    <b:elseif cond='data:blog.url == &quot;https://ouyi-cs.blogspot.com/2015/12/downgrade-rpms-using-ansible.html&quot;'/>
      <link href='https://ouyi.github.io/cicd/2015/12/14/ansible-downgrade-rpm.html' rel='canonical'/>
      <meta content='0; url=https://ouyi.github.io/cicd/2015/12/14/ansible-downgrade-rpm.html' http-equiv='refresh'/>
    <b:elseif cond='data:blog.url == &quot;http://ouyi-cs.blogspot.com/2015/12/downgrade-rpms-using-ansible.html&quot;'/>
      <link href='https://ouyi.github.io/cicd/2015/12/14/ansible-downgrade-rpm.html' rel='canonical'/>
      <meta content='0; url=https://ouyi.github.io/cicd/2015/12/14/ansible-downgrade-rpm.html' http-equiv='refresh'/>

    <!-- one such block for each post migrated ... -->

    <b:else/>
    </b:if>

    <!-- ... -->
</head>
{% endhighlight %}

The code snippet can be added to the Blogspot HTML template (in blogger.com Web UI, click "Theme", then "Edit HTML"), directly after the opening `<head>` tag. For each migrated post, it will generate two tags (link and meta) in the head section of the Blogspot version. The meta tag with `http-equiv='refresh'` takes care of redirecting the browser to the Github version. The link tag tells search engines that the Github version is the one (and the only one) to be indexed. Note also that I had to take care of both the `http` and `https` URLs for the Blogspot version. The syntax seems to be overwhelmingly verbose (working with Jekyll and Liquid, its template system, is way easier). If you find a cleaner or shorter way of doing this, please let me know. More details about the Blogspot template syntax [can be found here](https://support.google.com/blogger/answer/46995?hl=en&ref_topic=6321969).

After a few weeks, search engines will remove the Blogspot version from their indexed pages and index the Github one. The indexing process is quite out of our control. One has to be patient. From what I observed, Google seems to have picked up the posts on the new site faster than Bing and Yahoo. The following are a couple of articles related to "page URL changes" I found useful:

- [Move a site with URL changes](https://support.google.com/webmasters/answer/6033049)
- [Handling legitimate cross-domain content duplication](https://webmasters.googleblog.com/2009/12/handling-legitimate-cross-domain.html)
- [301 redirect for specific post in Blogger blog?](https://webapps.stackexchange.com/questions/6140/301-redirect-for-specific-post-in-blogger-blog)

## Customisations

While Jekyll supports a lot of themes which work quite well out of the box, it
allows customisations of almost everything of the site. A theme is a pre-defined
set of styles, templates, and template variables. My site is based on the default
Jekyll theme: minima. The command `bundle show minima` can be used to find the location
where the theme artefacts are installed, e.g.:

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

To override the theme defaults, simply copy the related file from the theme installation location to your project, under the same folder. For example, the following customisation adds feed link in the header:

```
[ouyi.github.io]$ diff .bundle/gems/minima-2.1.1/_includes/header.html _includes/header.html
27a28
>           <a class="page-link" href="{{ "/feed.xml" | relative_url }}"><i class="fa fa-rss" aria-hidden="true"></i></a>
```

As another example, to include custom styles, make a copy of the main.scss file and add lines to import from any custom style sheets.

```
[ouyi.github.io]$ diff .bundle/gems/minima-2.1.1/assets/main.scss assets/main.scss
5a6
> @import "custom";
[ouyi.github.io]$ ls _sass/
custom.scss
```

By default, bundler installs gems in a central location shared by all ruby
projects. To change that, set `BUNDLE_DISABLE_SHARED_GEMS` to true in the bundler config file, e.g.:

```
cat .bundle/config
---
BUNDLE_DISABLE_SHARED_GEMS: "true"
```

## Pagination and links to the previous and next posts

By default, the minima's home page shows the complete list of posts, which is not nice. What I would prefer are:

1. split the home page into multiple pages, if that list become long
2. control the number of posts displayed per page
3. link from each page to the previous and next pages

It turns out that Jekyll already has some support for [pagination](https://jekyllrb.com/docs/pagination/). To enable it, one has to add a line to the `_config.yml` file, specifying the number of items per page, e.g.: `paginator: 8`. With pagination enabled, Jekyll populates a `paginator` liquid object. [This is my changes to the home layout](https://github.com/ouyi/ouyi.github.io/compare/e270fd4...ef26966#diff-891082c144b1c9ddb0047d67a7b4181f) to implement pagination for the home page, making use of the paginator object.

Basically, instead of iterating over `site.posts`, one has to loop over `paginator.posts`. In addition to the post title, I also show a excerpt of the post content for preview `{{ post.excerpt | strip_html | truncatewords: 40, "" }}` and provides a `read more` button linking to the complete post content.

The links to the previous and next posts are implemented as a macro in the [prev_next.html file](https://github.com/ouyi/ouyi.github.io/blob/master/_includes/prev_next.html). The macro requires four named parameters: `prev_url`, `prev_text`, `next_url`, and `next_text`. This line includes the macro and passes the required parameters:

```
include prev_next.html prev_url=paginator.previous_page_path prev_text='Previous page' next_url=paginator.next_page_path next_text='Next page'
```

Note that pagination only works with the index.html file, which references the home layout file. I also had to rename the file index.md (default) to index.html to fix this error:  

```
Pagination: Pagination is enabled, but I couldn't find an index.html page to use as the pagination template. Skipping pagination.
```



Template engines generally provide no support of object assignment? Not easy to extract the pagination logic.

categories and tags: category => post, tags => tags page (indexing by tags)

[Create "read more" links](http://www.seanbuscay.com/blog/jekyll-teaser-pager-and-read-more/)

[Links to prev and next posts](http://david.elbe.me/jekyll/2015/06/20/how-to-link-to-next-and-previous-post-with-jekyll.html)
