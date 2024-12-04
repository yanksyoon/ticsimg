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
USRID=1001
GRPID=1001
USRNAME="runner"
groupadd -g $GRPID -o $USRNAME
useradd -m -u $USRID -g $GRPID -o -s /bin/bash $USRNAME
echo "$USRNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USRNAME
chmod 0440 /etc/sudoers.d/$USRNAME

echo $TICSAUTHTOKEN;

# Switch to the new user
sudo -i -u $USRNAME -E bash << EOF

export TICSAUTHTOKEN # - we need this to be injected to the user environment
echo $TICSAUTHTOKEN

# Download and install TiCS
curl -o /home/$USRNAME/install_tics.sh -L "https://canonical.tiobe.com/tiobeweb/TICS/api/public/v1/fapi/installtics/Script?cfg=default&platform=linux&url=https://canonical.tiobe.com/tiobeweb/TICS/"
chmod +x /home/$USRNAME/install_tics.sh
./install_tics.sh

source /home/$USRNAME/.profile

# Run additional TiCS maintenance commands
TICSMaintenance -checkchk
EOF

echo "TICS installed successfully"
