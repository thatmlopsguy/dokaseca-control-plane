#!/bin/bash

# Constants
ALLOWED_ENVIRONMENTS=("dev" "stg" "prod")
ALLOWED_ACTIONS=("apply" "destroy")
ALLOWED_CLUSTERS=("hub" "spokes")
SCRIPT_NAME="${0##*/}"

# Display usage information
show_usage() {
    echo "Usage: ${SCRIPT_NAME} <CLUSTER> <ENVIRONMENT> <ACTION>"
    echo ""
    echo "Arguments:"
    echo "  CLUSTER     Cluster type (hub/spokes)"
    echo "  ENVIRONMENT Environment type (dev/stg/prod)"
    echo "  ACTION      Action to perform (apply/destroy)"
    echo ""
    echo "Example:"
    echo "  ${SCRIPT_NAME} hub dev apply"
    echo "  ${SCRIPT_NAME} spokes prod destroy"
}

# Validate environment value
validate_environment() {
    local env=$1
    for allowed_env in "${ALLOWED_ENVIRONMENTS[@]}"; do
        if [ "${env}" = "${allowed_env}" ]; then
            return 0
        fi
    done
    return 1
}

# Validate cluster value
validate_cluster() {
    local cluster=$1
    for allowed_cluster in "${ALLOWED_CLUSTERS[@]}"; do
        if [ "${cluster}" = "${allowed_cluster}" ]; then
            return 0
        fi
    done
    return 1
}

# Validate action value
validate_action() {
    local action=$1
    for allowed_action in "${ALLOWED_ACTIONS[@]}"; do
        if [ "${action}" = "${allowed_action}" ]; then
            return 0
        fi
    done
    return 1
}

# Confirm destructive action
confirm_destructive_action() {
    echo "WARNING: This will destroy all resources in workspace '${WORKSPACE}'"
    read -r -p "Are you sure you want to continue? (yes/no): " confirmation

    if [[ ! "${confirmation}" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        echo "Operation cancelled"
        exit 0
    fi
}

# Main script
main() {
    # Input validation
    if [ $# -ne 3 ]; then
        show_usage
        exit 1
    fi

    CLUSTER=$1
    ENV=$2
    ACTION=$3

    # Validate inputs
    if ! validate_cluster "${CLUSTER}"; then
        echo "Error: Invalid cluster type '${CLUSTER}'"
        echo "Cluster must be one of: ${ALLOWED_CLUSTERS[*]}"
        exit 1
    fi

    if ! validate_environment "${ENV}"; then
        echo "Error: Invalid environment '${ENV}'"
        echo "Environment must be one of: ${ALLOWED_ENVIRONMENTS[*]}"
        exit 1
    fi

    if ! validate_action "${ACTION}"; then
        echo "Error: Invalid action '${ACTION}'"
        echo "Action must be one of: ${ALLOWED_ACTIONS[*]}"
        exit 1
    fi

    WORKSPACE="${CLUSTER}-${ENV}"

    # Get project root directory
    PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
        echo "Error: Not in a git repository"
        exit 1
    fi

    # Change directory and initialize terraform
    cd "${PROJECT_ROOT}/terraform" || {
        echo "Error: Could not change to terraform directory"
        exit 1
    }

    echo "Initializing terraform..."
    terraform init || {
        echo "Error: Failed to initialize terraform"
        exit 1
    }

    # Workspace management
    echo "Checking workspace '${WORKSPACE}'"
    if terraform workspace select "${WORKSPACE}" >/dev/null 2>&1; then
        echo "Workspace '${WORKSPACE}' already exists"
    else
        echo "Workspace '${WORKSPACE}' doesn't exist, creating..."
        terraform workspace new "${WORKSPACE}" || {
            echo "Error: Failed to create workspace '${WORKSPACE}'"
            exit 1
        }
    fi

    # Switch to workspace
    echo "Switching to workspace '${WORKSPACE}'..."
    terraform workspace select "${WORKSPACE}" || {
        echo "Error: Failed to switch to workspace '${WORKSPACE}'"
        exit 1
    }

    # Perform requested action
    if [ "${ACTION}" = "destroy" ]; then
        confirm_destructive_action

        echo "Destroying terraform configuration..."
        terraform destroy -var-file="tfvars/${CLUSTER}/${ENV}.tfvars" -auto-approve || {
            echo "Error: Failed to destroy terraform configuration"
            exit 1
        }
        echo "Successfully destroyed!"
    elif [ "${ACTION}" = "apply" ]; then
        echo "Applying terraform configuration..."
        terraform apply -var-file="tfvars/${CLUSTER}/${ENV}.tfvars" -auto-approve || {
            echo "Error: Failed to apply terraform configuration"
            exit 1
        }
        echo "Successfully completed!"
    fi
}

# Run main function
main "$@"
