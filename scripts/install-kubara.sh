#!/usr/bin/env bash
#
# Install Kubara CLI
#

set -e
cmd="kubara --version"

if command -v kubara &>/dev/null; then
    echo "Kubara is already installed. Skipping installation."
    $cmd
    exit 0
else
    echo "Kubara is not installed. Proceeding with installation."
    curl -sSLf https://raw.githubusercontent.com/kubara-io/kubara/refs/heads/main/install.sh | sh
    echo "Kubara installation completed."
    $cmd
fi
