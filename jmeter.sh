#!/bin/bash

set -e

JMETER_VERSION="5.6.3"
ARCHIVE="apache-jmeter-${JMETER_VERSION}.tgz"
INSTALL_DIR="/opt/apache-jmeter-${JMETER_VERSION}"
DOWNLOAD_URL="https://dlcdn.apache.org/jmeter/binaries/${ARCHIVE}"

sudo apt-get update
sudo apt-get install -y wget ca-certificates

cd /tmp

wget -O "${ARCHIVE}" "${DOWNLOAD_URL}"

tar -tzf "${ARCHIVE}" >/dev/null

sudo tar -xzf "${ARCHIVE}" -C /opt

sudo ln -sfn "${INSTALL_DIR}/bin/jmeter" /usr/local/bin/jmeter

rm -f "${ARCHIVE}"
