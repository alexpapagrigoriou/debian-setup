#!/bin/bash

set -e

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/monitors.sh"
    exit 1
fi

SOURCE="$(realpath "$1")"
DEST="/usr/local/bin/display-setup.sh"

if [[ ! -f "$SOURCE" || ! -r "$SOURCE" ]]; then
    echo "Error: Source file does not exist or is not readable: $SOURCE"
    exit 1
fi

if [[ "$SOURCE" != "$DEST" ]]; then
    sudo install -o root -g root -m 755 "$SOURCE" "$DEST"
fi

sudo mkdir -p /etc/lightdm/lightdm.conf.d

printf '[Seat:*]\ndisplay-setup-script=%s\n' "$DEST" | sudo tee /etc/lightdm/lightdm.conf.d/display-setup.conf >/dev/null

sudo chmod 644 /etc/lightdm/lightdm.conf.d/display-setup.conf
