#!/bin/sh
set -o errexit
set -o nounset

export PATH=$ENV_PATH:$PATH

echo "Cleaning up runner..."

docker system prune -af
docker volume prune -f
apt-get clean
rm -rf /usr/local/lib/android /opt/ghc /usr/share/dotnet /usr/local/share/boost
