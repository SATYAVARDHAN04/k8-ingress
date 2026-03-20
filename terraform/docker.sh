#!/bin/bash

# --------------------------------
# Install Docker on RHEL/CentOS
# --------------------------------
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to Docker group (logout/login needed for effect)
usermod -aG docker ec2-user

# --------------------------------
# Disk Expansion (optional, only if you resized volume in AWS)
# --------------------------------
growpart /dev/nvme0n1 4
lvextend -L +20G /dev/RootVG/rootVol
lvextend -L +10G /dev/RootVG/varVol

# Grow the XFS filesystems
xfs_growfs /
xfs_growfs /var

echo "✅ Docker installation complete. Please log out and log back in for Docker group permissions to apply."
