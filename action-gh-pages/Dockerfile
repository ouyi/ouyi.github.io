FROM ruby:2.5-alpine

COPY ../Gemfile ./

RUN apk update \
&& apk add --virtual .build-deps ruby-dev build-base \
&& bundle install \
&& apk del .build-deps \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

WORKDIR /usr/src/app
ENTRYPOINT ["/entrypoint.sh"]
