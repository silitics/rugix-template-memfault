#!/bin/bash

install -D -m 644 "${RECIPE_DIR}/files/memfaultd.conf" -t /etc

# Inject configuration from local environment.
echo ".env" >> "${LAYER_REBUILD_IF_CHANGED}"
. "${RUGIX_PROJECT_DIR}/.env"
sed -i "s@%%MEMFAULT_PROJECT_KEY%%@${MEMFAULT_PROJECT_KEY}@g" /etc/memfaultd.conf
MEMFAULT_SOFTWARE_VERSION=${MEMFAULT_SOFTWARE_VERSION:-$(date -u +"%Y%m%d%H%M%S")}
sed -i "s@%%MEMFAULT_SOFTWARE_VERSION%%@${MEMFAULT_SOFTWARE_VERSION}@g" /etc/memfaultd.conf
MEMFAULT_HARDWARE_VERSION=${MEMFAULT_HARDWARE_VERSION:-"rugix-${RECIPE_PARAM_DEVICE_TYPE}-${RUGIX_ARCH}"}
sed -i "s@%%MEMFAULT_HARDWARE_VERSION%%@${MEMFAULT_HARDWARE_VERSION}@g" /usr/bin/memfault-device-info
