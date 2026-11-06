#!/bin/bash

set -e

sudo apt update

sudo apt install -y git git-lfs
git lfs install

cat >"$HOME/.gitconfig" <<'EOF'
[user]
	name = Alexandros Papagrigoriou
	email = apapagrigoriou17@gmail.com
[init]
	defaultBranch = main
[push]
	autoSetupRemote = true
[core]
	autocrlf = input
EOF

mkdir -p "$HOME/.local/bin"

cat >"$HOME/.local/bin/git-remote-setup" <<'EOF'
#!/bin/bash

set -e

if [ "$#" -ne 0 ]; then
    echo "Usage: git-setup-remote"
    echo "Error: this command does not take any arguments"
    exit 1
fi

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Error: not inside a git repository"
    exit 1
}

GITHUB_USER="alexpapagrigoriou"
REPO_NAME=$(basename "$PWD")

GITHUB_REPO_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}"
GITLAB_REPO_URL="git@gitlab.com:${GITHUB_USER}/${REPO_NAME}"

git remote remove origin 2>/dev/null || true

git remote add origin "$GITHUB_REPO_URL"
git remote set-url --add --push origin "$GITHUB_REPO_URL"
git remote set-url --add --push origin "$GITLAB_REPO_URL"

git fetch
EOF
chmod +x "$HOME/.local/bin/git-remote-setup"

cat >"$HOME/.local/bin/git-clone-setup" <<'EOF'
#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: git-clone-setup <repo-name>"
    exit 1
fi

REPO_NAME="$1"

GITHUB_USER="alexpapagrigoriou"
GITHUB_REPO_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}"

git clone "$GITHUB_REPO_URL"

cd "$REPO_NAME"

git-remote-setup
EOF
chmod +x "$HOME/.local/bin/git-clone-setup"
