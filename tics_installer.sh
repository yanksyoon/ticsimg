#!/bin/bash

# Ensure the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Define environment variables
export DEBIAN_FRONTEND=noninteractive

# Update package lists and install dependencies
apt-get update
apt-get install -y \
    curl \
    bash \
    sudo \
    build-essential \
    git \
    flake8 \
    pylint

# Set up a new user
UID=1001
GID=1001
UNAME="runner"
groupadd -g $GID -o $UNAME
useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
echo "$UNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$UNAME
chmod 0440 /etc/sudoers.d/$UNAME

# Switch to the new user
sudo -i -u $UNAME bash << EOF

# TICSAUTHTOKEN need to be exported to the environment

# Download and install TiCS
curl -o /home/$UNAME/install_tics.sh -L "https://canonical.tiobe.com/tiobeweb/TICS/api/public/v1/fapi/installtics/Script?cfg=default&platform=linux&url=https://canonical.tiobe.com/tiobeweb/TICS/"
chmod +x /home/$UNAME/install_tics.sh
./install_tics.sh

# Run additional TiCS maintenance commands
TICSMaintenance -checkchk
