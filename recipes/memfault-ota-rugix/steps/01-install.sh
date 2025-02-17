#!/bin/bash

install -D -m 755 "${RECIPE_DIR}/files/memfault-ota-rugix" -t /usr/bin
install -D -m 644 "${RECIPE_DIR}/files/memfault-ota-rugix.service" -t /lib/systemd/system
install -D -m 644 "${RECIPE_DIR}/files/memfault-ota-rugix.timer" -t /lib/systemd/system

systemctl enable memfault-ota-rugix.timer