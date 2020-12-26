#!/bin/sh

bundle install && \
bundle exec jekyll build --safe && \
bundle exec htmlproofer ./_site --disable-external
