#!/bin/bash

set -euo pipefail

# Inject public SSH key from local environment file.
echo ".env" >> "${LAYER_REBUILD_IF_CHANGED}"
. "${RUGIX_PROJECT_DIR}/.env"
echo "${DEV_SSH_KEY:-""}" >>"${RUGIX_ROOT_DIR}/root/.ssh/authorized_keys"
