#!/bin/bash

echo "enabled=False" >"$HOME/.config/user-dirs.conf"

# Point all the standard dirs at $HOME so apps don't recreate them
cat >"$HOME/.config/user-dirs.dirs" <<'EOF'
XDG_DESKTOP_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/"
XDG_DOWNLOAD_DIR="$HOME/"
XDG_MUSIC_DIR="$HOME/"
XDG_PICTURES_DIR="$HOME/"
XDG_PUBLICSHARE_DIR="$HOME/"
XDG_TEMPLATES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/"
EOF

for d in Desktop Documents Downloads Music Pictures Public Templates Videos; do
    rmdir "$HOME/$d" 2>/dev/null
done
