#!/bin/bash

set -e

sudo sed -i -E 's/^\s*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub

sudo update-grub
