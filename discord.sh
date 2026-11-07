#!/bin/bash

set -e

TMP=$(mktemp -d)

curl -fL "https://discord.com/api/download?platform=linux&format=deb" -o "$TMP/discord.deb"
sudo apt install -y "$TMP/discord.deb"

rm -rf "$TMP"
