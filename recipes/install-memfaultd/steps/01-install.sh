#!/bin/bash

set -euo pipefail

case "${RUGIX_ARCH}" in
    "amd64")
        TARGET="x86_64-unknown-linux-musl"
        ;;
    "arm64")
        TARGET="aarch64-unknown-linux-musl"
        ;;
    *)
        echo "Unsupported architecture '${RUGIX_ARCH}'."
        exit 1
esac

RELEASE_URL="https://github.com/memfault/memfaultd/releases/download/${RECIPE_PARAM_VERSION}/memfaultd-${TARGET}"

echo "Downloading memfaultd binary from ${RELEASE_URL}"
curl -sfSL -o /usr/bin/memfaultd "${RELEASE_URL}"
echo "Downloaded memfaultd ✅"

chmod 755 /usr/bin/memfaultd

ln -sf /usr/bin/memfaultd /usr/bin/memfaultctl
ln -sf /usr/bin/memfaultd /usr/sbin/memfault-core-handler

install -D -m 755 "${RECIPE_DIR}/files/memfault-device-info" -t /usr/bin
install -D -m 644 "${RECIPE_DIR}/files/memfaultd.service" -t /lib/systemd/system
install -D -m 644 "${RECIPE_DIR}/files/persist-memfaultd.toml" -t /etc/rugpi/state

systemctl enable memfaultd
