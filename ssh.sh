#!/bin/bash

set -e

mkdir -p "$HOME/.ssh/config.d"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"

cat >"$HOME/.ssh/config" <<'EOF'
Include ~/.ssh/config.d/*

Host *
    AddKeysToAgent yes
EOF

cat >"$HOME/.ssh/config.d/git" <<'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_git
    IdentitiesOnly yes

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_git
    IdentitiesOnly yes
EOF

chmod 600 "$HOME/.ssh/config" "$HOME/.ssh/config.d/"*

if [ ! -f "$HOME/.ssh/id_git" ]; then
    ssh-keygen -t ed25519 -C "apapagrigoriou17@gmail.com" -f "$HOME/.ssh/id_git" -N ""
fi
