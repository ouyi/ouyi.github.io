FROM ruby:2.7-alpine

RUN apk update \
&& apk add ruby-dev build-base libcurl \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
