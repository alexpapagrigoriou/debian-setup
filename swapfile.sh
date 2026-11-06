#!/bin/bash

set -e

sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab

SWAP_UUID="$(findmnt -no UUID -T /swapfile)"
SWAP_OFFSET="$(sudo filefrag -v /swapfile | awk '$1=="0:" {sub(/\.\./,"",$4); print $4}')"

echo "UUID: $SWAP_UUID"
echo "Offset: $SWAP_OFFSET"

[ -n "$SWAP_UUID" ] && [ -n "$SWAP_OFFSET" ] || {
    echo "Empty UUID or offset, aborting"
    exit 1
}

echo "RESUME=UUID=$SWAP_UUID" | sudo tee /etc/initramfs-tools/conf.d/resume
sudo update-initramfs -u -k all

sudo sed -i -E "s/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet resume=UUID=$SWAP_UUID resume_offset=$SWAP_OFFSET\"/" /etc/default/grub
sudo update-grub
