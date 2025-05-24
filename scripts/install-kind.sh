#!/bin/bash
set -e

# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind-linux https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind-linux https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-arm64
chmod +x ./kind-linux
sudo mv ./kind-linux /usr/local/bin/kind
