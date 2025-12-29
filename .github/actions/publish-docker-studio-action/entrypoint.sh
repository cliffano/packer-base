#!/bin/bash
docker --version
source /home/.virtualenvs/py36/bin/activate
make clean stage deps lint build-docker-base
cat logs/packer-docker-base.log
echo "${DOCKERHUB_TOKEN}" | docker login --username cliffano --password-stdin
docker inspect cliffano/base
make publish-docker-base