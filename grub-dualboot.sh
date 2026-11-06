#!/bin/bash

set -e

DEBIAN_NAME="Debian 13"
WINDOWS_NAME="Windows 11"

findmnt /boot >/dev/null && {
    echo "/boot is a separate partition, not supported."
    exit 1
}

ROOT_UUID=$(findmnt -no UUID /)

WIN_LINE=$(sudo os-prober 2>/dev/null | grep -m1 'Windows Boot Manager' || true)
[ -n "$WIN_LINE" ] || {
    echo "os-prober did not find Windows. Install it: sudo apt install os-prober"
    exit 1
}

WIN_DEV=${WIN_LINE%%@*} # e.g. /dev/nvme0n1p1
WIN_PATH=${WIN_LINE#*@}
WIN_PATH=${WIN_PATH%%:*} # e.g. /efi/Microsoft/Boot/bootmgfw.efi
WIN_UUID=$(sudo blkid -s UUID -o value "$WIN_DEV")
[ -n "$WIN_UUID" ] || {
    echo "Could not read UUID of $WIN_DEV"
    exit 1
}

if ! grep -q "menuentry \"$DEBIAN_NAME\"" /etc/grub.d/40_custom; then
    sudo tee -a /etc/grub.d/40_custom >/dev/null <<EOF
menuentry "$DEBIAN_NAME" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /vmlinuz root=UUID=$ROOT_UUID ro quiet
    initrd /initrd.img
}
EOF
fi

# Windows entry (once)
if ! grep -q "menuentry \"$WINDOWS_NAME\"" /etc/grub.d/40_custom; then
    sudo tee -a /etc/grub.d/40_custom >/dev/null <<EOF
menuentry "$WINDOWS_NAME" {
    insmod part_gpt
    insmod fat
    search --no-floppy --fs-uuid --set=root $WIN_UUID
    chainloader $WIN_PATH
}
EOF
fi

sudo chmod -x /etc/grub.d/10_linux /etc/grub.d/30_uefi-firmware /etc/grub.d/30_os-prober

sudo update-grub
