#!/usr/bin/env bash

URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE_DIR="./vm_utils"
mkdir $IMAGE_DIR

pushd $IMAGE_DIR
wget $URL
popd 
