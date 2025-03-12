set dotenv-load

run SYSTEM="customized-efi-arm64":
    ./run-bakery run {{SYSTEM}}

build SYSTEM="customized-efi-arm64" BUNDLE_ARGS="":
    ./run-bakery bake image {{SYSTEM}}
    ./run-bakery bake bundle {{SYSTEM}} {{BUNDLE_ARGS}}

upload SYSTEM="customized-efi-arm64":
    #!/usr/bin/env bash
    set -euo pipefail
    BUNDLE_PATH="build/{{SYSTEM}}/system.rugixb"
    if [ ! -e "$BUNDLE_PATH" ]; then
        echo "ERROR: Need to build bundle first. Run 'just build {{SYSTEM}}'."
        exit 1
    fi
    . "build/{{SYSTEM}}/artifacts/memfault-vars"
    echo "MEMFAULT_SOFTWARE_VERSION=${MEMFAULT_SOFTWARE_VERSION}"
    echo "MEMFAULT_HARDWARE_VERSION=${MEMFAULT_HARDWARE_VERSION}"
    if command -v memfault >/dev/null; then
        MEMFAULT="memfault"
    elif command -v uvx >/dev/null; then
        MEMFAULT="uvx --from memfault-cli memfault"
    else
        echo "ERROR: Neither 'memfault' nor 'uvx' found."
        exit 1
    fi
    $MEMFAULT \
        --project "${MEMFAULT_PROJECT_SLUG}" \
        --org "${MEMFAULT_ORG_SLUG}" \
        --org-token "${MEMFAULT_ORG_TOKEN}" \
        upload-ota-payload \
        --hardware-version "${MEMFAULT_HARDWARE_VERSION}" \
        --software-type rugix-debian \
        --software-version "${MEMFAULT_SOFTWARE_VERSION}" \
        "$BUNDLE_PATH"

ssh:
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 root@127.0.0.1