#!/usr/bin/env bash


echo "Let's enable libvirt before running our vm!"
sudo systemctl enable libvirtd --now

sudo virt-install \
--name ubuntu-cloud-vm \
--memory 2048 \
--vcpus 1 \
--disk path=vm_utils/noble-server-cloudimg-amd64.img,format=qcow2,bus=virtio \
--disk path=vm_utils/seed.iso,device=cdrom \
--import \
--os-variant ubuntu24.04 \
--network network=default,model=virtio \
--noautoconsole \
--graphics none
