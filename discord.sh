#!/bin/bash

set -e

sudo apt update
sudo apt install -y wget

wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"

sudo apt install -y /tmp/discord.deb

rm -f /tmp/discord.deb
