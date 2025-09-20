#!/usr/bin/env bash

set -euo pipefail

tools=( "qemu-system-x86" "qemu-kvm" "qemu-utils" "libvirt-clients" "libvirt-daemon-system" "virtinst")

for tool in "${tools[@]}"; do 
  echo "Installing $tool"
  sudo apt install $tool
done

