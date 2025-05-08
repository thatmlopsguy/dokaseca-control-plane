#!/bin/bash

# Exit on error
set -e

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# Configuration
TFDOCS_CMD="terraform-docs"
TFDOCS_CONFIG="${PROJECT_ROOT}/.terraform-docs.yml"
DEBUG=false

# Debug logging
log_debug() {
    if [[ "$DEBUG" == true ]]; then
        echo "[DEBUG] $@"
    fi
}

# Check if terraform-docs is installed
if ! command -v "$TFDOCS_CMD" &> /dev/null; then
    log_debug "terraform-docs not found in PATH"
    echo "Error: terraform-docs is not installed or not in PATH"
    exit 1
fi

# Check if config file exists
if [ ! -f "$TFDOCS_CONFIG" ]; then
    log_debug "Config file $TFDOCS_CONFIG not found"
    echo "Error: terraform-docs configuration file '$TFDOCS_CONFIG' not found"
    exit 1
fi

# Generate documentation
log_debug "Generating documentation..."
$TFDOCS_CMD -c "$TFDOCS_CONFIG" $PROJECT_ROOT


echo "Successfully updated Terraform documentation"
