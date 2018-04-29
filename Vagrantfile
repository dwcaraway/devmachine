# -*- mode: ruby -*-
# vi: set ft=ruby :

# Minimal vagrant version required by vagrant-hostmanager plugin
Vagrant.require_version('>= 1.8.6')

# Check required plugins
REQUIRED_PLUGINS = %w(vagrant-vbguest).freeze

def provisioning?
  ARGV[0].downcase == "provision"
end

REQUIRED_PLUGINS.each do |plugin|
  raise "Missing required plugin. Install the latest plugin version with\n\nvagrant plugin install #{plugin}" unless Vagrant.has_plugin?(plugin) or not provisioning?
end

VM_BOX = "bento/centos-7.3".freeze
VM_BOX_VERSION = "2.3.2"
SCRIPT_DIR = File.dirname(__FILE__)
REPO_DIR = File.expand_path(File.join(SCRIPT_DIR, ".."))
MAPPED_REPO_DIR = File.join("/home", "vagrant", "repos")

# Check to see if the git submodules were recursively loaded
unless File.exists?(File.join(SCRIPT_DIR, "dotfiles", ".vim", "bundle", "syntastic", ".git"))
  raise "Missing required submodules. Download submodules with\n\ngit submodule update --init --recursive"
end

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = VM_BOX
  config.vm.box_version = VM_BOX_VERSION

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Forward default jupyter dev server port
  config.vm.network "forwarded_port", guest: 8888, host: 8888

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder(REPO_DIR, MAPPED_REPO_DIR)

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "4096"

    # Add video memory
    vb.customize ["modifyvm", :id, "--vram", "12"]

    # Add multi-cpu support
    vb.cpus = 2
  end

  # Ansible galaxy roles requires Git, preload that prior to running the playbook
  config.vm.provision("shell", :path => "shell/ansible_requirements.sh")

  #Provision with ansible_local (supported on Windows host)
  config.vm.provision("ansible_local") do |ansible_local|
    ansible_local.playbook = "ansible/playbook.yml"
    ansible_local.inventory_path = "ansible/hosts"

    # Load ansible galaxy files. Right now, we don't require any so commenting out
    ansible_local.galaxy_role_file = "ansible/required_roles.yml"
  end
end
