#!/bin/bash

# Required tools and their commands to check versions
declare -A tools=(
  [docker]="docker --version"
  [terraform]="terraform --version"
  [kind]="kind --version"
  [k0s]="k0s version"
  [k3d]="k3d --version"
  [jq]="jq --version"
  [helm]="helm version --short"
  [kubectl]="kubectl version --client"
  [kustomize]="kustomize version"
  [k9s]="k9s version"
)

# Check each tool and display its version
for tool in "${!tools[@]}"; do
  echo -n "Checking ${tool}... "
  if command -v ${tool} &> /dev/null; then
    echo "Installed"
    ${tools[$tool]}
  else
    echo "Not Installed"
  fi
  echo
done
