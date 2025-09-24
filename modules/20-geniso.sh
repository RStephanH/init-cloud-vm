#!/usr/bin/env bash

# Interactive generator for cloud-init user-data and meta-data

VM_UTILS_DIR="./vm_utils"
OUTPUT_DIR="./cloud-init"
mkdir -p "$OUTPUT_DIR" 

echo "=== Cloud-Init Config Generator ==="

# =========================
# ASK USER INPUTS
# =========================
read -rp "Enter instance hostname (default: my-vm): " HOSTNAME
HOSTNAME=${HOSTNAME:-my-vm}

read -rp "Enter admin username (default: admin): " USERNAME
USERNAME=${USERNAME:-admin}

read -rp "Enter your SSH public key path (default: ~/.ssh/id_rsa.pub): " SSH_KEY_PATH
SSH_KEY_PATH=${SSH_KEY_PATH:-~/.ssh/id_rsa.pub}

if [[ ! -f $SSH_KEY_PATH ]]; then
  echo "❌ SSH key not found at $SSH_KEY_PATH"
  echo "Generate a new one ..."
  read -rp "Enter your email address :" mail
  ssh-keygen -t rsa -b 4096 -C "comment|$mail"
fi
SSH_KEY=$(cat "$SSH_KEY_PATH")

read -rp "Enter comma-separated packages to install (default: curl,vim,git): " PKGS
PKGS=${PKGS:-curl,vim,git}

read -rp "Enter timezone (default: UTC): " TIMEZONE
TIMEZONE=${TIMEZONE:-UTC}

# =========================
# META-DATA FILE
# =========================
cat > "$OUTPUT_DIR/meta-data" <<EOF
instance-id: iid-$(uuidgen | tr '[:upper:]' '[:lower:]')
local-hostname: $HOSTNAME
EOF

# =========================
# USER-DATA FILE
# =========================
cat > "$OUTPUT_DIR/user-data" <<EOF
#cloud-config

hostname: $HOSTNAME
manage_etc_hosts: true

users:
  - name: $USERNAME
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin, sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - $SSH_KEY

package_update: true
package_upgrade: true
packages:
$(echo "$PKGS" | tr ',' '\n' | sed 's/^/  - /')

runcmd:
  - echo "Hello from $HOSTNAME via cloud-init" > /etc/motd
  - timedatectl set-timezone $TIMEZONE

final_message: "The system is finally up, after \$UPTIME seconds"
EOF

# =========================
# OUTPUT INFO
# =========================
echo "✅ Cloud-init files created in $OUTPUT_DIR/"
ls -l "$OUTPUT_DIR"

echo ""
echo "👉 To create an ISO for cloud-init, run:"
echo "   genisoimage -output seed.iso -volid cidata -joliet -rock $OUTPUT_DIR/user-data $OUTPUT_DIR/meta-data"

read -rp "Would you like to generate the ISO for cloud-init (y/N):" confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
  geniso="genisoimage -output $VM_UTILS_DIR/seed.iso -volid cidata -joliet -rock $OUTPUT_DIR/user-data $OUTPUT_DIR/meta-data"
  eval $geniso
fi
