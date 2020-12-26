FROM ruby:2.5-alpine

RUN apk update \
&& apk add --virtual .build-deps ruby-dev build-base alpine-sdk \
&& apk del .build-deps \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
