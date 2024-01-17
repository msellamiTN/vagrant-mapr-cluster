#!/bin/bash

# common/tasks/main.yml

# Update package cache for Debian-based systems
  apt-get update
 
# Install miscellaneous packages
packages=("mc" "wget" "python3-mysqldb" "openssl" "syslinux-utils" "libpython3.8" "curl")
for package in "${packages[@]}"
do
   apt-get install -y "$package"
done
 # Ensure that the default umask for the root user is set to 0022
echo 'umask 0022' >> /etc/profile

 
# Verify Java JDK 11 installation and install if not present
if ! command -v java &>/dev/null; then
     apt-get install -y openjdk-11-jdk
fi

# Add Java temporary directory configuration
# Customize the temporary directory location if needed
java_tmp_dir="/opt/mapr/tmp"
mkdir -p "$java_tmp_dir"
chmod 1777 "$java_tmp_dir"
 
# Install NTP
 apt-get install -y ntp

# Start the NTP service
service ntp start

# Install RPC bind
 apt-get install -y rpcbind

# Start the RPC bind service
service rpcbind start

# Set system parameters in /etc/sysctl.conf
sysctl_config="/etc/sysctl.conf"
echo "vm.swappiness = 1" >> "$sysctl_config"
echo "net.ipv4.tcp_retries2 = 5" >> "$sysctl_config"
echo "vm.overcommit_memory = 0" >> "$sysctl_config"
echo "net.ipv4.tcp_fin_timeout = 30" >> "$sysctl_config"

# Reload sysctl settings
sysctl -p

#!/bin/bash

# Define the JAVA_HOME path
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# Check if JAVA_HOME is already set in ~/.bashrc
if ! grep -q "^export JAVA_HOME=" ~/.bashrc; then
    # If not set, add JAVA_HOME to ~/.bashrc
    echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
fi

# Load the updated ~/.bashrc
source ~/.bashrc

# Verify JAVA_HOME
echo "JAVA_HOME is set to: $JAVA_HOME"

sudo chmod u+s /sbin/unix_chkpwd