#!/bin/bash

set -e

# kind version
KIND_VERSION="${KIND_VERSION:-v0.29.0}"

# For AMD64 / x86_64
[ "$(uname -m)" = x86_64 ] && curl -Lo ./kind-linux "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
# For ARM64
[ "$(uname -m)" = aarch64 ] && curl -Lo ./kind-linux "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-arm64"

chmod +x ./kind-linux

sudo mv ./kind-linux /usr/local/bin/kind

# print kind version
kind --version
