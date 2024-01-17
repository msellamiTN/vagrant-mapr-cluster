#!/bin/bash

# Install the Data Fabric package key

# Set your email and token values as variables
HPE_PASSPORT_EMAIL="mokhtar.sellami@data2-ai.com"
HPE_PASSPORT_TOKEN="mEkRZt6iQ20DXpB0Rkta9ZxNO_SKDMUBNk5I1BZnEUYzIKBkRBblulDSu94hBAiA996vy23UocIeIVsY0V1eGg"

# Install the package key
wget --user="$HPE_PASSPORT_EMAIL" --password="$HPE_PASSPORT_TOKEN" -O /tmp/maprgpg.key -q https://package.ezmeral.hpe.com/releases/pub/maprgpg.key
sudo apt-key add /tmp/maprgpg.key

# Clean up the temporary key file
rm -f /tmp/maprgpg.key

# End of script
