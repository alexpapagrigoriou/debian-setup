#!/bin/bash

set -e

BASE=https://services.gradle.org/distributions
VERSION=$(curl -fsSL "$BASE/" |
    grep -oP 'gradle-\K[0-9]+\.[0-9]+(\.[0-9]+)?(?=-bin\.zip")' |
    sort -Vu |
    tail -1)

[ -n "$VERSION" ] || {
    echo "Could not detect Gradle version"
    exit 1
}

DEST="$HOME/.local/gradle-$VERSION"

if [ -d "$DEST" ]; then
    echo "Gradle $VERSION already installed"
    exit 0
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"

FILE="gradle-$VERSION-bin.zip"

curl -fLO "$BASE/$FILE"
curl -fLO "$BASE/$FILE.sha256"

HASH=$(tr -d '[:space:]' <"$FILE.sha256")
echo "$HASH  $FILE" | sha256sum -c -

mkdir -p "$HOME/.local"

unzip -q "$FILE" -d "$TMP"

mv "$TMP/gradle-$VERSION" "$DEST"

ln -sfn "$DEST" "$HOME/.local/gradle"

mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.local/gradle/bin/gradle" "$HOME/.local/bin/gradle"

for d in "$HOME"/.local/gradle-[0-9]*; do
    [ -d "$d" ] || continue
    [ "$d" = "$DEST" ] || rm -rf "$d"
done

exit 0
