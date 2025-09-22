#!/usr/bin/env bash

set -euo pipefail

tools=( "qemu-system" "qemu-kvm" "qemu-utils" "libvirt-clients" "libvirt-daemon-system" "virtinst" "cloud-utils")

for tool in "${tools[@]}"; do 
  echo "Installing $tool"
  sudo apt install $tool
done

