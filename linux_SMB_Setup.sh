#!/bin/bash

# Prompt user for storage node IP
read -p "Enter the storage node IP address: " SHARE_IP

# Define other variables
SHARE_NAME="AIQT"
MOUNT_POINT="/mnt"
USER_ID=$(id -u)
GROUP_ID=$(id -g)
FSTAB_ENTRY="//${SHARE_IP}/${SHARE_NAME}  ${MOUNT_POINT}  cifs  guest,uid=${USER_ID},gid=${GROUP_ID}  0  0"

# Install CIFS utils (for both Ubuntu/Debian and RHEL/CentOS)
if [ -f /etc/debian_version ]; then
    echo "Detected Debian-based system. Installing cifs-utils..."
    sudo apt update
    sudo apt install cifs-utils -y
elif [ -f /etc/redhat-release ]; then
    echo "Detected RHEL-based system. Installing cifs-utils..."
    sudo yum install cifs-utils -y
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

# Create mount point if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point at $MOUNT_POINT"
    sudo mkdir -p "$MOUNT_POINT"
fi

# Mount the SMB share
echo "Mounting SMB share at //${SHARE_IP}/${SHARE_NAME}..."
sudo mount -t cifs //${SHARE_IP}/${SHARE_NAME} "$MOUNT_POINT" -o guest,uid=${USER_ID},gid=${GROUP_ID}

# Add entry to /etc/fstab for persistent mount
echo "Updating /etc/fstab for persistent mount..."
if ! grep -qs "${SHARE_IP}" /etc/fstab; then
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab > /dev/null
    echo "Entry added to /etc/fstab."
else
    echo "Entry already exists in /etc/fstab."
fi

echo "Done!"
