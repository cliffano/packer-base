<img align="right" src="https://raw.github.com/cliffano/packer-base/master/avatar.jpg" alt="Avatar"/>

[![Build Status](https://github.com/cliffano/packer-base/workflows/CI/badge.svg)](https://github.com/cliffano/packer-base/actions?query=workflow%3ACI)
[![Docker Pulls Count](https://img.shields.io/docker/pulls/cliffano/base.svg)](https://hub.docker.com/r/cliffano/base/)
[![Security Status](https://snyk.io/test/github/cliffano/packer-base/badge.svg)](https://snyk.io/test/github/cliffano/packer-base)

Packer Base
-----------

Packer Base is a Packer builder of Docker base image which contains vanilla Ubuntu OS with some common tools.

Installation
------------

Pull Base Docker image from Docker Hub:

    docker pull cliffano/base

Or alternatively, you can create the Docker image:

    git clone https://github.com/cliffano/packer-base
    cd packer-base
    make docker

An image with `cliffano/base` repository and `latest` tag should show up:

    haku> docker images

    REPOSITORY                                       TAG                 IMAGE ID            CREATED             SIZE
    cliffano/base                                  latest              3f45c1bc0e76        5 hours ago         1.5GB
    ubuntu                                           latest              735f80812f90        2 weeks ago         83.5MB

Usage
-----

Simply run a container using cliffano/base image:

    docker run \
      --rm \
      --workdir /opt/workspace \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v $(pwd):/opt/workspace \
      -i -t cliffano/base

Development
-----------

Extra path should be added to the following:

* provisioners/shell/info-pre.sh
* provisioners/shell/info-post.sh
* templates/packer/docker-base.pkr.hcl