#!/bin/bash

set -e

sudo apt update

sudo apt install -y keyd

sudo tee "/etc/keyd/default.conf" >/dev/null <<'EOF'
[ids]
*

[main]
capslock = leftcontrol
leftcontrol = capslock
backslash = backspace
backspace = backslash
EOF

sudo systemctl enable --now keyd
sudo systemctl restart keyd
