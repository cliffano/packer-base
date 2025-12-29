#!/bin/sh
set -o errexit
set -o nounset

export PATH=$ENV_PATH:$PATH

echo "****************************************"
echo "* Provisioned software info - Post"
echo "****************************************"
echo "PATH: $PATH"
echo "brew version: $(brew --version)"
echo "cyclonedx version: $(cyclonedx --version)"
echo "jq version: $(jq --version)"
echo "netstat version: $(netstat --version)"
echo "shellcheck version: $(shellcheck --version)"
echo "telnet version: $(telnet --version)"
echo "vim version: $(vim --version)"
echo "yq version: $(yq --version)"
echo "zip version: $(zip --version)"
