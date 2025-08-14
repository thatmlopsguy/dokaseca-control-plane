#!/bin/bash

arch=$(if [[ "$(uname -m)" == "x86_64" ]]; then echo "amd64"; else uname -m; fi)
os=$(uname -s | tr '[:upper:]' '[:lower:]')

idpbuilder_latest_tag=$(curl --silent "https://api.github.com/repos/cnoe-io/idpbuilder/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

curl -LO  https://github.com/cnoe-io/idpbuilder/releases/download/$idpbuilder_latest_tag/idpbuilder-$os-$arch.tar.gz
tar xvzf idpbuilder-$os-$arch.tar.gz

sudo mv idpbuilder /usr/local/bin/

rm -rf LICENSE idpbuilder-$os-$arch.tar.gz
