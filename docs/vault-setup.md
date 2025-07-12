# HashiCorp Vault Setup Guide

This document provides step-by-step instructions for setting up HashiCorp Vault using Docker Compose with persistent storage.

## Prerequisites

- Docker and Docker Compose installed
- Basic understanding of Vault concepts
- Terminal access

## Architecture

- **Storage Backend**: File-based storage with Docker volume persistence
- **Network**: HTTP (TLS disabled for local development)
- **UI**: Enabled and accessible via web browser
- **Persistence**: All secrets stored in `vault-data` Docker volume

## Setup Instructions

### 1. Start Vault Service

```bash
docker compose up -d vault
```

### 2. Verify Vault is Running

Check the logs to ensure Vault started successfully:

```bash
docker logs vault
```

You should see logs indicating the server started, but will show "security barrier not initialized" - this is expected.

### 3. Initialize Vault

Initialize Vault to generate unseal keys and root token:

```bash
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault operator init'
```

**Important**: Save the output securely! You'll get:

- 5 unseal keys (need 3 to unseal)
- 1 root token (for initial admin access)

### 4. Unseal Vault

Vault needs to be unsealed with 3 of the 5 keys every time it starts:

```bash
# First unseal key
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal <UNSEAL_KEY_1>'

# Second unseal key
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal <UNSEAL_KEY_2>'

# Third unseal key (Vault will be unsealed after this)
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal <UNSEAL_KEY_3>'
```

### 5. Verify Vault Status

Check that Vault is fully operational:

```bash
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault status'
```

Look for `Sealed: false` in the output.

## Access Methods

### Web UI

- URL: <http://localhost:8200>
- Login: Use the root token from initialization

### Command Line

```bash
# Set environment variable for convenience
export VAULT_ADDR=http://localhost:8200

# Login with root token
vault auth -method=token token=<ROOT_TOKEN>

# Or run commands directly in container
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault <COMMAND>'
```

## Configuration Files

### docker-compose.yml

Located at project root, contains:

- Vault service definition
- Volume mounts for data persistence
- Network configuration

### configs/vault/local.json

Vault configuration file with:

- File storage backend
- HTTP listener (TLS disabled)
- UI enabled
- Logging configuration

## Maintenance Tasks

### Stop Vault

```bash
docker compose down vault
```

### Start Existing Vault

```bash
docker compose up -d vault
# Then unseal with 3 keys (same process as step 4 above)
```

### View Logs

```bash
docker logs vault -f
```

### Backup Vault Data

```bash
# Create backup of vault data volume
docker run --rm -v vault-data:/data -v $(pwd):/backup ubuntu tar czf /backup/vault-backup.tar.gz -C /data .
```

### Restore Vault Data

```bash
# Restore from backup
docker run --rm -v vault-data:/data -v $(pwd):/backup ubuntu tar xzf /backup/vault-backup.tar.gz -C /data
```

## Security Considerations

⚠️ **Important Security Notes**:

1. **Unseal Keys**: Store the 5 unseal keys securely and separately
2. **Root Token**: Change or revoke the initial root token after setup
3. **TLS**: This setup uses HTTP for local development - enable TLS for production
4. **Access Control**: Implement proper authentication methods beyond root token
5. **Backups**: Regularly backup the vault data volume
6. **Network**: Restrict network access in production environments

## Troubleshooting

### Common Issues

**Vault won't start**:

- Check Docker logs: `docker logs vault`
- Verify configuration file syntax
- Ensure ports aren't in use

**Cannot connect to Vault**:

- Verify Vault is unsealed: `vault status`
- Check VAULT_ADDR environment variable
- Ensure using HTTP not HTTPS for local setup

**Lost unseal keys**:

- If you have root token, you can rekey: `vault operator rekey`
- Otherwise, you'll need to reinitialize (data loss)

**Permission errors**:

- Check Docker volume permissions
- Verify container user has access to mounted directories

### Useful Commands

```bash
# Check seal status
vault status

# List enabled auth methods
vault auth list

# List enabled secret engines
vault secrets list

# Read vault configuration
vault read sys/config/state/sanitized

# Generate new unseal keys (requires existing keys)
vault operator rekey
```

## Production Considerations

For production use, consider:

1. **TLS Configuration**: Enable HTTPS with proper certificates
2. **High Availability**: Use Consul or other HA storage backend
3. **Auto-unseal**: Configure auto-unseal with cloud HSM or transit
4. **Monitoring**: Set up monitoring and alerting
5. **Access Policies**: Implement least-privilege access policies
6. **Regular Backups**: Automated backup strategy
7. **Network Security**: Firewall rules and network segmentation

## Example Initial Setup Script

```bash
#!/bin/bash
set -e

echo "Starting Vault..."
docker compose up -d vault

echo "Waiting for Vault to start..."
sleep 10

echo "Initializing Vault..."
INIT_OUTPUT=$(docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault operator init')
echo "$INIT_OUTPUT"

# Extract keys and token (you should do this more securely)
UNSEAL_KEY_1=$(echo "$INIT_OUTPUT" | grep "Unseal Key 1:" | awk '{print $4}')
UNSEAL_KEY_2=$(echo "$INIT_OUTPUT" | grep "Unseal Key 2:" | awk '{print $4}')
UNSEAL_KEY_3=$(echo "$INIT_OUTPUT" | grep "Unseal Key 3:" | awk '{print $4}')

echo "Unsealing Vault..."
docker exec -it vault sh -c "VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal $UNSEAL_KEY_1"
docker exec -it vault sh -c "VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal $UNSEAL_KEY_2"
docker exec -it vault sh -c "VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal $UNSEAL_KEY_3"

echo "Vault is ready!"
docker exec -it vault sh -c 'VAULT_ADDR=http://127.0.0.1:8200 vault status'
```
