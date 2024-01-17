 
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Enable the experimental disks feature via environment variable, requires Vagrant >=2.2.8.
ENV["VAGRANT_EXPERIMENTAL"] = "disks"

# Port mappings for MapR Master Node
  master_ports = {
    7222 => 7222, # CLDB
    7221 => 7221, # CLDB web
    5181 => 5181, # Zookeeper
    8032 => 8032, # ResourceManager
    19888 => 19888, # JobHistory Server
    8443 => 8443, # WebServer HTTPS
    8080 => 8080 # WebServer HTTP
  }

  # Port mappings for MapR Worker Nodes
  worker_ports = {
    8042 => 8042, # NodeManager
    50010 => 50010, # DataNode data transfer
    50075 => 50075, # DataNode HTTP
    5660 => 5660 # FileServer NFS
  }

  # Port mappings for MapR Edge Node
  edge_ports = {
    # 22 => 2220, # SSH
    9443 => 9443, # Installer web HTTPS
    # Add other client-specific ports if needed
  }

Vagrant.configure("2") do |config|
    # Disable the automatic update of VirtualBox Guest Additions
    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
    # Edge Node
    config.vm.define "mapr-edge" do |edge|
      edge.vm.box = "ubuntu/focal64"
      edge.vm.hostname = "edge.htc-ezmeral.local"
      
       # Set memory, CPU, and disk resources
       edge.vm.disk :disk, size: "30GB", primary: true   
       edge.vm.disk :disk, size: "120GB", name: "mapr_data"
       edge.vm.provider "virtualbox" do |vb|
        vb.memory = 12000  # 24 GB RAM
        vb.cpus = 4        # 4 CPUs
       
      end
      edge_ports.each do |guest, host|
         edge.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
      end
      edge.vm.network "forwarded_port", guest: 22, host: 2220 , id: "ssh", auto_correct: true
      # NAT adapter for internet access
      edge.vm.network "public_network",  type: "static", ip: "192.168.56.10", bridge: "ens160"
      # Internal/private network for communication between VMs
      edge.vm.network "private_network", type: "static", ip: "192.168.56.10", virtualbox__intnet: true , name: "mapr-cluster-net" 
      edge.vm.provision "file", source: "external_hosts", destination: "/tmp/hosts"
      edge.vm.provision "shell", inline: <<-SHELL
      sudo echo "127.0.0.1 localhost edge edge.htc-ezmeral.local" | sudo tee -a /tmp/hosts
      sudo mv /tmp/hosts | sudo tee -a /etc/hosts
        SHELL
    end
    # Master Node
   
     config.vm.define "mapr-master" do |master|
      master.vm.box = "ubuntu/focal64"
      master.vm.hostname = "master.htc-ezmeral.local"
       # Set memory, CPU, and disk resources
      master.vm.disk :disk, size: "30GB", primary: true 
      master.vm.disk :disk, size: "120GB", name: "mapr_data"
      master.vm.provider "virtualbox" do |vb|
        vb.memory = 24576  # 24 GB RAM
        vb.cpus = 8        # 8 CPUs
        
      end
      # NAT adapter for internet access
      master.vm.network "public_network",  type: "static", ip: "192.168.56.11", bridge: "ens160"
      # Internal/private network for communication between VMs
      master.vm.network "private_network", type: "static", ip: "192.168.56.11", virtualbox__intnet: true , name: "mapr-cluster-net"
      master_ports.each do |guest, host|
        master.vm.network "forwarded_port", guest: guest, host: host
     end
      master.vm.network "forwarded_port", guest: 22, host: 2221, id: "ssh", auto_correct: true
      master.vm.provision "file", source: "external_hosts", destination: "/tmp/hosts"
      master.vm.provision "shell", inline: <<-SHELL
      sudo echo "127.0.0.1 localhost master master.htc-ezmeral.local " | sudo tee -a /tmp/hosts
      sudo cat /tmp/hosts | sudo tee -a /etc/hosts
        SHELL
    end
  
    # Worker Nodes
    (1..3).each do |i|
      config.vm.define "mapr-worker#{i}" do |worker|
        worker.vm.box = "ubuntu/focal64"
        worker.vm.hostname = "worker#{i}.htc-ezmeral.local"
         # Set memory, CPU, and disk resources
         worker.vm.disk :disk, size: "20GB", primary: true 
         worker.vm.disk :disk, size: "150GB", name: "mapr_data"
         worker.vm.provider "virtualbox" do |vb|
          vb.memory =12000  # 12 GB RAM
          vb.cpus = 4        # 4 CPUs
          
        end
           # NAT adapter for internet access
           worker.vm.network "public_network", type: "static", ip: "192.168.56.#{11 + i}", bridge: "ens160"
        # Internal/private network for communication between VMs
        worker.vm.network "private_network", type: "static", ip: "192.168.56.#{11 + i}", virtualbox__intnet: true , name: "mapr-cluster-net"
        worker.vm.network "forwarded_port", guest: 22, host: 2221 + i , id: "ssh", auto_correct: true
        worker_ports.each do |guest, host|
          worker.vm.network "forwarded_port", guest: guest, host: host + i,  auto_correct: true
       end
       worker.vm.provision "file", source: "external_hosts", destination: "/tmp/hosts"
          worker.vm.provision "shell", inline: <<-SHELL
              sudo echo "127.0.0.1 localhost worker#{i} worker#{i}.htc-ezmeral.local "  | sudo tee -a /tmp/hosts
              sudo mv /tmp/hosts | sudo tee -a /etc/hosts
            SHELL 
      end
    end
       # Provisioning with a shell script
           # Provisioning with a shell script
    
     # Copy hosts file
     config.vm.provision "file", source: "/home/user2/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
     config.vm.provision "file", source: "/home/user2/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
     config.vm.provision "file", source: "/home/user2/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/authorized_keys"         
    #installation of mapr common prequistes
    config.vm.provision "shell", path: "./common/common.sh"
  end
  
