#!/bin/bash

arch=$(uname -m)
[ "$arch" = "x86_64" ] && arch=amd64
curl -L -o kargo https://github.com/akuity/kargo/releases/latest/download/kargo-"$(uname -s | tr '[:upper:]' '[:lower:]')-${arch}"
chmod +x kargo
