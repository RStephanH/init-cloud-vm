#!/usr/bin/env bash

VM_UTILS_DIR="./vm_utils"
IMAGE="noble-server-cloudimg-amd64.img"
SEE_ISO=

virt-install \
--name ubuntu-cloud-vm \
--memory 2048 \
--vcpus 1 \
--disk path=$"VM_UTILS_DIR"/noble-server-cloudimg-amd64.img,format=qcow2,bus=virtio \
--disk path=$"VM_UTILS_DIR"/seed.iso,device=cdrom \
--import \
--os-type linux \
--os-variant ubuntu22.04 \
--network network=default,model=virtio \
--noautoconsole \
--graphics none
