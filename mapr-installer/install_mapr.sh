#!/bin/bash

# Replace with your HPE Passport email and token
HPE_PASSPORT_EMAIL="mokhtar.sellami@data2-ai.com"
HPE_PASSPORT_TOKEN="mEkRZt6iQ20DXpB0Rkta9ZxNO_SKDMUBNk5I1BZnEUYzIKBkRBblulDSu94hBAiA996vy23UocIeIVsY0V1eGg"

# Define the necessary environment variables
export DATA_FABRIC_VERSION="7.5.0"
export PEM_FABRIC_VERSION="9.2.0"

# Download the mapr-setup.sh script to /tmp
wget --user="$HPE_PASSPORT_EMAIL" --password="$HPE_PASSPORT_TOKEN" -O /tmp/mapr-setup.sh https://package.ezmeral.hpe.com/releases/installer/mapr-setup.sh

# Make mapr-setup.sh executable
chmod +x /tmp/mapr-setup.sh

# Run mapr-setup.sh to configure the node, suppress prompts
yes | /tmp/mapr-setup.sh -r "https://$HPE_PASSPORT_EMAIL:$HPE_PASSPORT_TOKEN@package.ezmeral.hpe.com/releases/"

# Start the Installer
echo "Start the Installer by opening the following URL:"
echo "https://localhost:9443"
