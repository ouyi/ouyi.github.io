---
layout: post
title:  "Migrating from Blogspot to GitHub Pages"
date:   2017-10-14 07:56:11 +0000
last_modified_at: 2018-01-14 19:55:39
category: post
tags: [Blogging, Jekyll]
---

* TOC
{:toc}
Recently I migrated [my blog](https://ouyi.github.io) from Blogspot to [GitHub
Pages](https://github.com/ouyi/ouyi.github.io). It took a while, but I am glad
I did it, because blogging with GitHub Pages is much more enjoyable than with
Blogspot, as long as one is comfortable with Git and Markdown. More
specifically, I like GitHub Pages because:

1. Everything of the blog is version controlled, including posts, themes, and settings
2. Static site generators (I chose Jekyll) allow customizations of almost everything
3. Markdown produces much cleaner HTML pages than those produced by a WYSIWYG editor

With Blogspot I already had some of my posts in Markdown and in a Git
repository. But to publish a post there, I had to convert the post from
Markdown to HTML with some tools, and then paste the result page into the
Blogspot post editor Web UI.

Now with GitHub Pages and Jekyll, the workflow of blogging is like this:

1. Writing a post in Markdown with any text editor, and
2. Add, commit, and push the changes in Git

GitHub Pages will automatically run a `jekyll build` to generate the HTML pages,
which usually become online in a couple of seconds after the push.

The migration process, however, was not always straightforward. I took notes so
that it might be helpful for the readers.

## Travis CI

The downside of having GitHub Pages building everything automatically behind
the scenes is that if there is an issue, e.g., a Markdown syntax error, you
would not even notice it. Therefore, I configured it to be built also
automatically on Travis CI, which requires just a config file (`.travis.yml`)
[in the root folder of the
project](https://github.com/ouyi/ouyi.github.io/blob/master/.travis.yml):

{% highlight yml %}
language: ruby
cache: bundler
install:
  - bundle install
script:
  - bundle exec jekyll build --safe
  - bundle exec htmlproofer ./_site --disable-external
{% endhighlight %}

<!--_-->

This instructs Travis to generate the site (stored in the `_site` folder) and
run htmlproofer on it while ignoring the linked external sites. For all this to
work, of course, one has to connect the GitHub project in Travis CI, which is
out of scope of this post (and GitHub Pages also works without Travis CI).

When all this has been set up, one got email notifications from Travis
on build failures. One got also a small build passing (or failing) badge:

[![Build Status](https://travis-ci.org/ouyi/ouyi.github.io.svg?branch=master)](https://travis-ci.org/ouyi/ouyi.github.io)

The command htmlproofer is provided by the gem `html-proofer`. In addition, to
make sure the build on Travis has the same dependencies as the build on GitHub,
specify `gem 'github-pages', group: :jekyll_plugins` in the
[Gemfile](https://github.com/ouyi/ouyi.github.io/blob/master/Gemfile). Before
the changes are pushed, one can always run `bundle exec jekyll serve --port
8080 --host 0.0.0.0 --drafts` and open `http://localhost:8080` with the browser
to proof read the generated site.

## Hosting images

I mentioned earlier: "everything of the blog is version controlled". This does
NOT apply to images, because I do not think including images in a Git
repository is a great idea. But we need to host the images somewhere, e.g., S3,
CDN, or any other hosting services. The solution I chose was found on Statck
Overflow. It allows me to host my images on GitHub, based on a [secret GitHub
feature](https://stackoverflow.com/a/20959426/8886552).

Once I got the URL to the image, I can add the image using standard Markdown
syntax (i.e., `![alt text](image_url "title text")`) or the HTML `img` tag
(yes, in a Markdown file), e.g.:

{% highlight html %}
<img src="https://user-images.githubusercontent.com/15970333/32409768-84c92cc8-c1b2-11e7-9309-428c99da8cac.png" alt="screen shot 1">
{% endhighlight %}

## Redirects and canonical URL tags

After a post has been migrated, there are two versions of it on the Web: the
old one on Blogspot and the new one on GitHub. Simply removing the old version
would mean a bad user experience (they might have bookmarked the old version)
and would hurt SEO. Ideally, we would like to:

1. redirect the browser visiting the old version to the new version, and
2. tell search engines that the old version is obsolete and the new version is
the one to index.

After some searches, I came up with this kind of Blogspot template code
snippet:

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

The code snippet can be added to the Blogspot HTML template (in blogger.com Web
UI, click "Theme", then "Edit HTML"), directly after the opening `<head>` tag.
For each migrated post, it will generate two tags (link and meta) in the head
section of the Blogspot version. The meta tag with `http-equiv='refresh'` takes
care of redirecting the browser to the GitHub version. The link tag tells
search engines that the GitHub version is the one (and the only one) to be
indexed. Note also that I had to take care of both the `http` and `https` URLs
for the Blogspot version.

The syntax seems to be overwhelmingly verbose (working with Jekyll and Liquid,
its template system, is way easier). If you find a cleaner or shorter way of
doing this, please let me know. More details about the Blogspot template syntax
[can be found
here](https://support.google.com/blogger/answer/46995?hl=en&ref_topic=6321969).

After a few weeks, search engines will remove the Blogspot version from their
indexed pages and index the GitHub one. The indexing process is quite out of
our control. One has to be patient. From what I observed, Google seems to have
picked up the posts on the new site faster than Bing and Yahoo. The following
are a couple of articles related to "page URL changes" I found useful:

- [Move a site with URL changes](https://support.google.com/webmasters/answer/6033049)
- [Handling legitimate cross-domain content duplication](https://webmasters.googleblog.com/2009/12/handling-legitimate-cross-domain.html)
- [301 redirect for specific post in Blogger blog?](https://webapps.stackexchange.com/questions/6140/301-redirect-for-specific-post-in-blogger-blog)

The blog migration also involves customization of the Jekyll theme I chose, which
is described in [a separate post]({{ site.baseurl }}{% post_url 2017-12-23-jekyll-customization %}).
