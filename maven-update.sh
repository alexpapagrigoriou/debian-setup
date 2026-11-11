#!/bin/bash

set -e

BASE=https://dlcdn.apache.org/maven/maven-3

VERSION=$(curl -fsSL "$BASE/" |
    grep -oP 'href="\K[0-9]+\.[0-9]+\.[0-9]+(?=/")' |
    sort -Vu |
    tail -1)

[ -n "$VERSION" ] || {
    echo "Could not detect Maven version"
    exit 1
}

DEST="$HOME/.local/apache-maven-$VERSION"

if [ -d "$DEST" ]; then
    echo "Maven $VERSION already installed"
    exit 0
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"

FILE="apache-maven-$VERSION-bin.tar.gz"

curl -fLO "$BASE/$VERSION/binaries/$FILE"
curl -fLO "$BASE/$VERSION/binaries/$FILE.sha512"

HASH=$(tr -d '[:space:]' <"$FILE.sha512")

if ! [[ "$HASH" =~ ^[a-fA-F0-9]{128}$ ]]; then
    echo "Invalid SHA-512 checksum format"
    exit 1
fi

echo "$HASH  $FILE" | sha512sum -c -

mkdir -p "$HOME/.local"

tar -xzf "$FILE" -C "$TMP"

mv "$TMP/apache-maven-$VERSION" "$DEST"

ln -sfn "$DEST" "$HOME/.local/maven"
mkdir -p "$HOME/.local/bin"

ln -sf "$HOME/.local/maven/bin/mvn" "$HOME/.local/bin/mvn"

for d in "$HOME"/.local/apache-maven-[0-9]*; do
    [ -d "$d" ] || continue
    [ "$d" = "$DEST" ] || rm -rf "$d"
done

exit 0
