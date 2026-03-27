#!/bin/bash
#
# Install idpbuilder
# This script downloads the latest release of idpbuilder from GitHub, extracts it, and moves the binary to /usr/local/bin for easy access.

# Determine the architecture and operating system
arch=$(if [[ "$(uname -m)" == "x86_64" ]]; then echo "amd64"; else uname -m; fi)
os=$(uname -s | tr '[:upper:]' '[:lower:]')

# Fetch the latest release tag of idpbuilder from GitHub API
idpbuilder_latest_tag=$(curl --silent "https://api.github.com/repos/cnoe-io/idpbuilder/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Download the latest release of idpbuilder for the detected OS and architecture
curl -LO  https://github.com/cnoe-io/idpbuilder/releases/download/$idpbuilder_latest_tag/idpbuilder-$os-$arch.tar.gz
tar xvzf idpbuilder-$os-$arch.tar.gz

sudo mv idpbuilder /usr/local/bin/

rm -rf LICENSE idpbuilder-$os-$arch.tar.gz
