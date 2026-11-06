#!/bin/bash

set -e

sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab

SWAP_UUID="$(findmnt -no UUID -T /swapfile)"
SWAP_OFFSET="$(sudo filefrag -v /swapfile | awk '$1=="0:" {print $4}' | sed 's/\.\.//')"

echo "RESUME=UUID=$SWAP_UUID resume_offset=$SWAP_OFFSET" | sudo tee /etc/initramfs-tools/conf.d/resume
sudo update-initramfs -u -k all

sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 resume=UUID=$SWAP_UUID resume_offset=$SWAP_OFFSET\"|" /etc/default/grub
sudo update-grub
