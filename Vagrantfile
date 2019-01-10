# -*- mode: ruby -*-
# vi: set ft=ruby :

# Use Ubuntu instead of CentOS
# VM_BOX = 'bento/ubuntu-16.04'.freeze
VM_BOX = 'bento/centos-7.4'.freeze
VM_BOX_VERSION = '201803.24.0'.freeze
VRAM_MB = '128'

FORWARDED_PORTS = [1337, # strapi
                   8888, # jupyter dev server port
                   4200, # default ember port
                   49152, # ember livereload port
                   8081, # metra docker compose port
                   3000, # Django
                   8000] # Front end / gatsby
HOST_IP = '127.0.0.1'

SCRIPT_DIR = File.dirname(__FILE__)
REPO_DIR = File.expand_path(File.join(SCRIPT_DIR, '..'))
MAPPED_REPO_DIR = File.join('/home', 'vagrant', 'repos')

# Check required plugins
REQUIRED_PLUGINS = %w(vagrant-vbguest).freeze

def provisioning?
  ARGV[0].downcase == "provision"
end

REQUIRED_PLUGINS.each do |plugin|
  raise "Missing required plugin. Install the latest plugin version with\n\nvagrant plugin install #{plugin}" unless Vagrant.has_plugin?(plugin) or not provisioning?
end

# Check to see if the git submodule was checked out
unless File.exists?(File.join(SCRIPT_DIR, "dotfiles"))
  raise "Missing required submodule. Download submodules with\n\ngit submodule update --init"
end

Vagrant.configure('2') do |config|
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

  FORWARDED_PORTS.each do |port|
    config.vm.network 'forwarded_port', guest: port, host: port, host_ip: HOST_IP
  end

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
  config.vm.provider 'virtualbox' do |vb|
    # Customize the amount of memory on the VM in megabytes
    vb.memory = '4096'

    # Number of virtual CPUs to use
    vb.cpus = 2

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Add video memory (size in megabytes)
    vb.customize ['modifyvm', :id, '--vram', VRAM_MB]

    # Allow copy and paste experience for VirtualBox VMS
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
  end

  # Ansible galaxy roles requires Git, preload prior to running the playbook
  config.vm.provision('shell', path: 'shell/ansible_requirements.sh')

  # Provision with ansible_local
  config.vm.provision('ansible_local') do |ansible_local|
    ansible_local.install_mode = :pip
    ansible_local.playbook = 'ansible/playbook.yml'
    ansible_local.inventory_path = 'ansible/hosts'
    ansible_local.galaxy_role_file = 'ansible/required_roles.yml'
  end
end
