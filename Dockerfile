FROM ruby:2.7-alpine

COPY Gemfile ./

RUN apk update \
&& apk add --virtual .build-deps ruby-dev build-base \
&& bundle install \
&& apk del .build-deps \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

WORKDIR /usr/src/app
EXPOSE 8000
CMD bundle exec jekyll serve --port 8000 --host 0.0.0.0 --drafts 
