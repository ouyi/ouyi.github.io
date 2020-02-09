[![Build Status](https://travis-ci.org/ouyi/ouyi.github.io.svg?branch=master)](https://travis-ci.org/ouyi/ouyi.github.io)

# Memory Spills

Memory Spills is [a blog based on Jeykll and hosted on GitHub](https://ouyi.github.io).

## Useful commands

### Docker-based environment

The easiest method to have a running envrionment with everything installed:

    docker-compose up

Build the image:

    docker build . -t docker-github-pages

Start the container serving the static site:

    docker run -it -v "$PWD":/usr/src/app -p 8000:8000 docker-github-pages

Run a single command:

    docker run -it -v "$PWD":/usr/src/app -p 8000:8000 docker-github-pages bundle exec github-pages versions

### Host-based environment 

One-liner to set up the environment:

    curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -L get.rvm.io | bash -s stable \
    && bash -l -c 'source /etc/profile.d/rvm.sh \
    && rvm reload \
    && rvm requirements run \
    && rvm install 2.5.3 \
    && rvm use 2.5.3 --default \
    && gem install jekyll bundler sass'

Test locally:

    bundle exec jekyll serve --port 8000 --host 0.0.0.0 --drafts

Show a bundle package content:

    bundle show minima
    
Update the last_modified_at field of a post using its file system modification time:

    ./lastmod.sh _posts/2015-12-14-ansible-downgrade-rpm.md
