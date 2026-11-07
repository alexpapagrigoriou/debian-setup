#!/bin/bash

set -e

sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo tee /etc/lightdm/lightdm.conf.d/autofill-user.conf > /dev/null <<EOF
[Seat:*]
greeter-hide-users=false
greeter-show-manual-login=false
EOF
