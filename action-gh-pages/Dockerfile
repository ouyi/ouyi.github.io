FROM ruby:2.5-alpine

RUN apk update \
&& apk add --virtual .build-deps ruby-dev build-base \
&& apk del .build-deps \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]
