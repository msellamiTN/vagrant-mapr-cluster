#!/bin/bash

# Set your HPE Passport email and token
HPE_PASSPORT_EMAIL="mokhtar.sellami@data2-ai.com"
HPE_PASSPORT_TOKEN="mEkRZt6iQ20DXpB0Rkta9ZxNO_SKDMUBNk5I1BZnEUYzIKBkRBblulDSu94hBAiA996vy23UocIeIVsY0V1eGg"
DATA_FABRIC_VERSION="7.5.0"
PEM_FABRIC_VERSION="9.2.0"

# Create the authentication config file
cat <<EOF > /etc/apt/auth.conf.d/package.ezmeral.hpe.com.conf
machine package.ezmeral.hpe.com
login $HPE_PASSPORT_EMAIL
password $HPE_PASSPORT_TOKEN
EOF

# Add the Data Fabric Repository URLs to sources.list
cat <<EOF >> /etc/apt/sources.list
deb https://package.ezmeral.hpe.com/releases/v$DATA_FABRIC_VERSION/ubuntu/ binary bionic
deb https://package.ezmeral.hpe.com/releases/MEP/MEP-$PEM_FABRIC_VERSION/ubuntu/ binary bionic
EOF

# Update the package indexes
apt-get update

# End of script
