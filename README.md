[![Build Status](https://travis-ci.org/ouyi/ouyi.github.io.svg?branch=master)](https://travis-ci.org/ouyi/ouyi.github.io)

![Jekyll site CI](https://github.com/ouyi/ouyi.github.io/workflows/.github/workflows/Jekyll site CI/badge.svg)

![GitHub Pages build](https://github.com/ouyi/ouyi.github.io/workflows/.github/workflows/GitHub Pages build/badge.svg)

# Memory Spills

Memory Spills is [a blog based on Jeykll and hosted on GitHub](https://ouyi.github.io).

## Useful commands

### Docker-based environment

The easiest way to have a local test envrionment up and running is executing this command in a Linux or macOS console:

    docker-compose up

This will install all dependencies and bring up a test web server, all in a Docker container. If everything works, the following messages are displayed in the console:

    jekyll_1  |     Server address: http://0.0.0.0:8000/
    jekyll_1  |   Server running... press ctrl-c to stop.

The blog site is available for preview at `http://localhost:8000/`. 

If for whatever reason docker-compose is not wanted, the following manual steps can achieve the same effect. 

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
