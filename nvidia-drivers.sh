#!/bin/bash

set -e

if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    sudo sed -i -E '/^Components:/ {
    / contrib/! s/$/ contrib/
    / non-free( |$)/! s/$/ non-free/
    / non-free-firmware/! s/$/ non-free-firmware/
  }' /etc/apt/sources.list.d/debian.sources
fi

if [ -f /etc/apt/sources.list ] && grep -qE '^deb ' /etc/apt/sources.list; then
    sudo sed -i -E '/^deb / {
    / contrib/! s/$/ contrib/
    / non-free( |$)/! s/$/ non-free/
    / non-free-firmware/! s/$/ non-free-firmware/
  }' /etc/apt/sources.list
fi

sudo apt update
sudo apt install -y linux-headers-"$(dpkg --print-architecture)" dkms build-essential

sudo apt install -y nvidia-driver firmware-misc-nonfree

sudo apt install -y nvidia-smi

echo
echo "Done. Reboot now"
echo "After reboot, verify with:  nvidia-smi"
