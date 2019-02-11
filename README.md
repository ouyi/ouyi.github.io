[![Build Status](https://travis-ci.org/ouyi/ouyi.github.io.svg?branch=master)](https://travis-ci.org/ouyi/ouyi.github.io)

# Memory Spills

Memory Spills is [a blog based on Jeykll and hosted on GitHub](https://ouyi.github.io).

## Useful commands

One-liner to set up the environment:

    curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -L get.rvm.io | bash -s stable \
    && bash -l -c 'source /etc/profile.d/rvm.sh \
    && rvm reload \
    && rvm requirements run \
    && rvm install 2.4.1 \
    && rvm use 2.4.1 --default \
    && gem install jekyll bundler sass'

Test locally:

    bundle exec jekyll serve --port 8000 --host 0.0.0.0 --drafts

Show a bundle package content:

    bundle show minima
    
