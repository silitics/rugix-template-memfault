#!/bin/bash

set -euo pipefail

install -D -m 644 "${RECIPE_DIR}/files/memfaultd.conf" -t /etc

# Inject configuration from local environment.
echo ".env" >> "${LAYER_REBUILD_IF_CHANGED}"
. "${RUGIX_PROJECT_DIR}/.env"
sed -i "s@%%MEMFAULT_PROJECT_KEY%%@${MEMFAULT_PROJECT_KEY}@g" /etc/memfaultd.conf
MEMFAULT_SOFTWARE_VERSION=${MEMFAULT_SOFTWARE_VERSION:-$(date -u +"%Y%m%d%H%M%S")}
sed -i "s@%%MEMFAULT_SOFTWARE_VERSION%%@${MEMFAULT_SOFTWARE_VERSION}@g" /etc/memfaultd.conf
MEMFAULT_HARDWARE_VERSION=${MEMFAULT_HARDWARE_VERSION:-"${RECIPE_PARAM_DEVICE_TYPE}-${RUGIX_ARCH}"}
sed -i "s@%%MEMFAULT_HARDWARE_VERSION%%@${MEMFAULT_HARDWARE_VERSION}@g" /usr/bin/memfault-device-info

MEMFAULT_VARS_PATH="${RUGIX_ARTIFACTS_DIR}/memfault-vars"
MEMFAULT_VARS_DIR=$(dirname "${MEMFAULT_VARS_PATH}")

if [ ! -d "${MEMFAULT_VARS_DIR}" ]; then
    mkdir -p "${MEMFAULT_VARS_DIR}"
fi

echo "MEMFAULT_SOFTWARE_VERSION=${MEMFAULT_SOFTWARE_VERSION}" > "$MEMFAULT_VARS_PATH"
echo "MEMFAULT_HARDWARE_VERSION=${MEMFAULT_HARDWARE_VERSION}" >> "$MEMFAULT_VARS_PATH"
