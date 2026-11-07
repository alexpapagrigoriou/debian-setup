#!/bin/bash

set -e

TMP=$(mktemp -d)

cd "$TMP"

curl -fLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

rm -rf ~/.local/nvim
mkdir -p ~/.local/nvim

tar -C ~/.local/nvim --strip-components=1 -xzf nvim-linux-x86_64.tar.gz
ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim

rm -rf "$TMP"
