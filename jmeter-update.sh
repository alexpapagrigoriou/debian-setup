#!/bin/bash

set -e

BASE=https://dlcdn.apache.org/jmeter/binaries

VERSION=$(curl -fsSL "$BASE/" | grep -oP 'apache-jmeter-\K[0-9]+\.[0-9]+(\.[0-9]+)?(?=\.tgz")' | sort -V | tail -1)
[ -n "$VERSION" ] || {
    echo "Could not detect JMeter version"
    exit 1
}

DEST=~/.local/apache-jmeter-$VERSION
if [ -d "$DEST" ]; then
    echo "JMeter $VERSION already installed"
    exit 0
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"

curl -fLO "$BASE/apache-jmeter-$VERSION.tgz"
curl -fLO "$BASE/apache-jmeter-$VERSION.tgz.sha512"
sha512sum -c "apache-jmeter-$VERSION.tgz.sha512"

tar -C ~/.local -xzf "apache-jmeter-$VERSION.tgz"
ln -sfn "$DEST" ~/.local/jmeter

mkdir -p ~/.local/bin
ln -sf ~/.local/jmeter/bin/jmeter ~/.local/bin/jmeter

for d in ~/.local/apache-jmeter-*; do
    [ -d "$d" ] || continue
    [ "$d" != "$DEST" ] && rm -rf "$d"
done

exit 0
