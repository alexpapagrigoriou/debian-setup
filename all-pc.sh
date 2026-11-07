#!/bin/bash

scripts=(
    devtools.sh
    i3.sh
    git.sh
    ssh.sh
    remap.sh
    mirror.sh
    idle-pc.sh
    vscode.sh
    discord.sh
    docker.sh
    virtualbox.sh
)

cd "$(dirname "$0")" || exit 1

for f in "${scripts[@]}"; do
    if [ ! -f "$f" ]; then
        echo "ERROR: $f not found" >&2
        exit 1
    fi

    echo "=== Running $f ==="
    if ! bash "$f"; then
        echo "ERROR: $f failed, stopping here" >&2
        exit 1
    fi

    echo "--- $f succeeded, removing"
    echo ""
    rm -- "$f"
done

echo "reboot"
