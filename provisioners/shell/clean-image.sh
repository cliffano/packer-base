#!/bin/sh
set -o errexit
set -o nounset

export PATH=$ENV_PATH:$PATH

echo "Cleaning up image..."

brew cleanup --prune=all -s || true
rm -rf "$(brew --cache)"

export DEBIAN_FRONTEND="noninteractive"
apt-get autoremove -y --purge
apt-get clean
rm -rf /var/lib/apt/lists/*

rm -rf /var/cache/apt/*
rm -rf /var/cache/debconf/*-old
rm -rf /var/cache/man/*

rm -rf /root/.cache /root/.npm /root/.ansible

rm -rf /tmp/* /var/tmp/*
find /var/log -type f -exec truncate -s 0 {} +
