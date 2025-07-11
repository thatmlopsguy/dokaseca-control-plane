#!/bin/bash

PASSWORD="admin"
HASH=$(argocd account bcrypt --password "${PASSWORD}")
echo "${HASH}"
