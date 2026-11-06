#!/bin/bash

set -e

sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab

SWAP_UUID="$(findmnt -no UUID -T /swapfile)"
SWAP_OFFSET="$(sudo filefrag -v /swapfile | awk '$1=="0:" {print $4}' | sed 's/\.\.//')"

sudo sed -i "s/\$/ resume=UUID=$SWAP_UUID resume_offset=$SWAP_OFFSET/" /etc/kernel/cmdline

sudo sed -i '/^HOOKS=/ s/\budev\b/& resume/' /etc/mkinitcpio.conf

sudo mkinitcpio -P

echo ""
echo "reboot"
