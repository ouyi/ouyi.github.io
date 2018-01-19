---
layout: post
title:  "How does the GitHub Pages CNAME file work"
date:   2018-01-14 08:50:00 +0000
last_modified_at: 2018-01-14 19:52:06
category: post
tags: [Blogging, DNS]
---

* TOC
{:toc}
GitHub Pages support custom domains, i.e., sites hosted there can be accessed
via DNS names like `www.github.com`, in addition to the default DNS names like
`ouyi.github.io` or `ouyi.github.io/test`. I did some tests to figure out how
it works. Those tests are described below. To repeat them[^dns_cache], you need a
GitHub account and a test domain.

## Create a test project on GitHub

First, lets create a test project on GitHub. This is the test project I
created: [ouyi.github.io/test](https://ouyi.github.io/test). Based on this test
project, we can create a minimal working example for GitHub Pages. That
requires only a [minimalistic HTML index page on the special branch
`gh-pages`](https://github.com/ouyi/test/blob/gh-pages/index.html). With that
in place, we have created a so called [Project Pages
site](https://help.github.com/articles/user-organization-and-project-pages/),
which is accessible at `https://ouyi.github.io/test`.

Now we can test it with the `curl` command-line tool[^browsers].

```
$ curl -iL "http://ouyi.github.io/test"
HTTP/1.1 301 Moved Permanently
Server: GitHub.com
Content-Type: text/html
Location: https://ouyi.github.io/test
X-GitHub-Request-Id: C902:209A2:BA02A6E:1012C7CB:5A5B61BF
Content-Length: 178
Accept-Ranges: bytes
Date: Sun, 14 Jan 2018 14:02:13 GMT
Via: 1.1 varnish
Age: 294
Connection: keep-alive
X-Served-By: cache-hhn1522-HHN
X-Cache: HIT
X-Cache-Hits: 1
X-Timer: S1515938534.844165,VS0,VE0
Vary: Accept-Encoding
X-Fastly-Request-ID: 9bde18fb5f0118cbb043b30b9aae1850eed3796f

HTTP/1.1 301 Moved Permanently
Server: GitHub.com
Content-Type: text/html
Location: https://ouyi.github.io/test/
X-GitHub-Request-Id: C8FC:4765:17E5632:21B888F:5A5B61BF
Content-Length: 178
Accept-Ranges: bytes
Date: Sun, 14 Jan 2018 14:02:13 GMT
Via: 1.1 varnish
Age: 294
Connection: keep-alive
X-Served-By: cache-hhn1545-HHN
X-Cache: HIT
X-Cache-Hits: 2
X-Timer: S1515938534.941957,VS0,VE0
Vary: Accept-Encoding
X-Fastly-Request-ID: 93fba68c26ab60ad62d2ac5a6c584b787532adcf

HTTP/1.1 200 OK
Server: GitHub.com
Content-Type: text/html; charset=utf-8
Last-Modified: Sun, 14 Jan 2018 13:56:49 GMT
Access-Control-Allow-Origin: *
Expires: Sun, 14 Jan 2018 14:07:20 GMT
Cache-Control: max-age=600
X-GitHub-Request-Id: 6990:209A3:5583E4F:760347E:5A5B61BE
Content-Length: 79
Accept-Ranges: bytes
Date: Sun, 14 Jan 2018 14:02:13 GMT
Via: 1.1 varnish
Age: 294
Connection: keep-alive
X-Served-By: cache-hhn1545-HHN
X-Cache: HIT
X-Cache-Hits: 2
X-Timer: S1515938534.955052,VS0,VE0
Vary: Accept-Encoding
X-Fastly-Request-ID: 59d0f0fc8487678fe5e489f73b67f96c4de5afc8

<html>
    <head>
    </head>
    <body>
    Hello, World!
    </body>
</html>
```

Quite a lot was going on to serve our minimal `Hello, World!` page. The first
HTTP response redirects the user agent (`curl` or a browser) to the HTTPS
version of the same location. The second response redirects to the canonical
location (which has a trailing slash `/`) of the site. Finally, the third
response returns the HTML page.

## Setup

### Set up DNS

Now we will set up DNS to point our test domain names to the [GitHub Pages IP
addresses](https://help.github.com/articles/setting-up-an-apex-domain/).

We follow the convention to [create an _A record_ for the apex
domain](https://blog.cloudflare.com/zone-apex-naked-domain-root-domain-cname-supp/)
`builders-it.de` to be able to resolve it to an IP address (we picked
192.30.252.154), and a _CNAME record_ for the www subdomain
`www.builders-it.de` as an alias of `builders-it.de`. How to create those
records depends on the DNS provider. I use 1und1.de, which seems to only allow
one A record[^a_records] for the apex domain (a.k.a. the root domain). But that is
sufficient for our tests.

We can verify the DNS set up with the `dig` command-line tool[^host_cmd]. After some
minutes of waiting, the output shall look like the following:

```
$ dig www.builders-it.de +nostats +nocomments

; <<>> DiG 9.8.3-P1 <<>> www.builders-it.de +nostats +nocomments
;; global options: +cmd
;www.builders-it.de.		IN	A
www.builders-it.de.	3413	IN	CNAME	builders-it.de.
builders-it.de.		3413	IN	A	192.30.252.154
```

### Set up GitHub Pages redirect

Now we need to tell GitHub Pages our domain name. That can be done by creating
a [CNAME file containing the www
subdomain](https://github.com/ouyi/test/blob/gh-pages/CNAME), again, on the
special branch `gh-pages`. It could also be done using the GitHub Web UI, as
shown in the following screen shot:

![screen shot 2018-01-14 at 14 56 30](https://user-images.githubusercontent.com/15970333/34918207-7d8db288-f94f-11e7-8490-f6014c0567fc.png "GitHub Pages custom domain setting under project settings")

## Tests

### Requests using the custom domain name

```
$ curl -iL "http://www.builders-it.de"
HTTP/1.1 200 OK
Server: GitHub.com
Date: Sun, 14 Jan 2018 09:58:16 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 79
Vary: Accept-Encoding
Last-Modified: Sun, 14 Jan 2018 08:38:36 GMT
Vary: Accept-Encoding
Access-Control-Allow-Origin: *
Expires: Sun, 14 Jan 2018 10:08:16 GMT
Cache-Control: max-age=600
Accept-Ranges: bytes
X-GitHub-Request-Id: FB7C:7582:388994F:4EBCAA3:5A5B29B8

<html>
    <head>
    </head>
    <body>
    Hello, World!
    </body>
</html>
```

Cool, it works! The following command shows the requests sent to the server.

```
$ curl -iLv "http://www.builders-it.de" 2>&1 | grep '^> '
> GET / HTTP/1.1
> Host: www.builders-it.de
> User-Agent: curl/7.54.0
> Accept: */*
>
```

The GitHub Pages IP address (which is most likely a load balancer IP address)
in this example is resolved in two steps:

1. DNS figures out the canonical domain name (which is the root domain name in
our setup) for `www.builders-it.de` using the CNAME record, i.e.,
`www.builders-it.de => builders-it.de`.

2. DNS figures out the IP address for the canonical domain name using the A
record, i.e., `builders-it.de => 192.30.252.154`.

The CNAME could also be `www.builders-it.de => ouyi.github.io`, as documented
in the GitHub official documentation. In that case, the GitHub name servers are
responsible for resolving the IP address. The above two steps would be:

1. DNS figures out the canonical domain name (which is the root domain name in
our setup) for `www.builders-it.de` using the CNAME record, i.e.,
`www.builders-it.de => ouyi.github.io`.

2. GitHub Pages name servers figure out an IP address for the GitHub Pages
subdomain, i.e., `ouyi.github.io => some ip address`.

### Requests using the root domain name

Accessing the site using the root domain name involves a 301 redirect to the
www subdomain.

```
$ curl -iL "http://builders-it.de"
HTTP/1.1 301 Moved Permanently
Server: GitHub.com
Date: Sun, 14 Jan 2018 10:29:20 GMT
Content-Type: text/html
Content-Length: 178
Location: http://www.builders-it.de/
X-GitHub-Request-Id: CB47:7585:74DABB1:A2D8546:5A5B3100

HTTP/1.1 200 OK
Server: GitHub.com
Date: Sun, 14 Jan 2018 10:29:20 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 79
Vary: Accept-Encoding
Last-Modified: Sun, 14 Jan 2018 08:38:36 GMT
Vary: Accept-Encoding
Access-Control-Allow-Origin: *
Expires: Sun, 14 Jan 2018 10:39:20 GMT
Cache-Control: max-age=600
Accept-Ranges: bytes
X-GitHub-Request-Id: CB22:7582:389741B:4ED0158:5A5B3100

<html>
    <head>
    </head>
    <body>
    Hello, World!
    </body>
</html>
```

We can see there were two HTTP requests:

```
$ curl -iLv "http://builders-it.de" 2>&1 | grep '^> '
> GET / HTTP/1.1
> Host: builders-it.de
> User-Agent: curl/7.54.0
> Accept: */*
>
> GET / HTTP/1.1
> Host: www.builders-it.de
> User-Agent: curl/7.54.0
> Accept: */*
>
```

The first request goes directly to the GitHub Pages IP address (due to the A
record). The GitHub server at that address returns a 301 response, which
redirects the user agent to the www subdomain (because of the CNAME file). This
kind of redirect seems to be undocumented by GitHub Pages.

### Requests using the default DNS name

To see whether the default DNS name for the Project Pages site is still
working, we can repeat the very first test we did after we [created the test
project on GitHub](#create-a-test-project-on-github).

```
$ curl -iL "http://ouyi.github.io/test"
HTTP/1.1 301 Moved Permanently
Server: GitHub.com
Content-Type: text/html
Location: http://www.builders-it.de
X-GitHub-Request-Id: 6402:209A2:B8CB7A7:FF7EA72:5A5B2189
Content-Length: 178
Accept-Ranges: bytes
Date: Sun, 14 Jan 2018 09:47:55 GMT
Via: 1.1 varnish
Age: 1473
Connection: keep-alive
X-Served-By: cache-hhn1544-HHN
X-Cache: HIT
X-Cache-Hits: 1
X-Timer: S1515923275.411885,VS0,VE0
Vary: Accept-Encoding
X-Fastly-Request-ID: dbefaf4a7707a8401e813836d56100c55a5ab412

HTTP/1.1 200 OK
Server: GitHub.com
Date: Sun, 14 Jan 2018 09:47:55 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 79
Vary: Accept-Encoding
Last-Modified: Sun, 14 Jan 2018 08:38:36 GMT
Vary: Accept-Encoding
Access-Control-Allow-Origin: *
Expires: Sun, 14 Jan 2018 09:57:49 GMT
Cache-Control: max-age=600
Accept-Ranges: bytes
X-GitHub-Request-Id: FBCA:7582:38852CC:4EB67B9:5A5B274B

<html>
    <head>
    </head>
    <body>
    Hello, World!
    </body>
</html>
```

It works, but differently. There is no redirect to the HTTPS location and there
is no redirect to add the trailing slash. The first response redirects the user
agent to the www subdomain (due to the CNAME file).

```
$ curl -iLv "http://ouyi.github.io/test" 2>&1 | grep '^> '
> GET /test HTTP/1.1
> Host: ouyi.github.io
> User-Agent: curl/7.54.0
> Accept: */*
>
> Host: www.builders-it.de
> User-Agent: curl/7.54.0
> Accept: */*
>
```

Interestingly, the redirect to add the trailing slash still occurs when
requesting the HTTPS URL directly, and there is no redirect to the custom
domain.

```
$ curl -iL "https://ouyi.github.io/test"
HTTP/1.1 301 Moved Permanently
Server: GitHub.com
Content-Type: text/html
Location: https://ouyi.github.io/test/
X-GitHub-Request-Id: 6CE4:4767:42B367D:5DF0107:5A5BABD8
Content-Length: 178
Accept-Ranges: bytes
Date: Sun, 14 Jan 2018 19:13:28 GMT
Via: 1.1 varnish
Age: 0
Connection: keep-alive
X-Served-By: cache-hhn1541-HHN
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1515957208.141728,VS0,VE96
Vary: Accept-Encoding
X-Fastly-Request-ID: 0853013cea20df0ef053f4f85346032fffe9acea

HTTP/1.1 200 OK
Server: GitHub.com
Content-Type: text/html; charset=utf-8
Last-Modified: Sun, 14 Jan 2018 13:56:49 GMT
Access-Control-Allow-Origin: *
Expires: Sun, 14 Jan 2018 14:07:20 GMT
Cache-Control: max-age=600
X-GitHub-Request-Id: 6990:209A3:5583E4F:760347E:5A5B61BE
Content-Length: 79
Accept-Ranges: bytes
Date: Sun, 14 Jan 2018 19:13:28 GMT
Via: 1.1 varnish
Age: 0
Connection: keep-alive
X-Served-By: cache-hhn1541-HHN
X-Cache: HIT
X-Cache-Hits: 1
X-Timer: S1515957208.249646,VS0,VE134
Vary: Accept-Encoding
X-Fastly-Request-ID: b4f06f7769fd14f5924d09fe3729439816761733

<html>
    <head>
    </head>
    <body>
    Hello, World!
    </body>
</html>
```

## Conclusion

Settng up custom domain for GitHub Pages involves two aspects: 1. Set up the
domain names to point to the GitHub Pages IP address(es) 2. Add a CNAME file in
the project to redirect HTTP requests to the custom domain.

It seems that the DNS name in the CNAME file is used for the HTTP 301 redirect.
So, probably a better name for that file could be REDIRECT. Most of the DNS
providers nowadays also support HTTP redirects, which can be used, e.g., to
redirect HTTP requests to HTTPS locations. But they work the same way as the
GitHub redirect does, i.e., they use a Web server.

**Footnotes**

[^browsers]: Tests can also be done with browsers, e.g., Chrome developer tools.

[^a_records]: Some DNS providers support multiple A records for the apex domain.

[^host_cmd]: Similar information can also be obtained using the commands `host -a www.builders-it.de` and `host -a builders-it.de`.

[^dns_cache]: While doing DNS-related tests, it might be helpful to flush the host DNS cache from time to time, which can be done with various methods, e.g., you can clear host DNS cache with Chrome by opening the URL `chrome://net-internals/#dns` and click the corresponding button on that page, or if you are on a macbook with macOS Sierra, the host DNS cache can be cleared by the command `sudo killall -HUP mDNSResponder`.
