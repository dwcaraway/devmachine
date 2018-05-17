# Devmachine
A portable development environment.

## Prerequisites
* [Git](https://git-scm.com/downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

**Windows Users**
Windows users will need a terminal simulator that supports SSH such as
* [Babun](http://babun.github.io)

## Check Out the Source Code
Ensure that all submodules and their submodules are checked out using the ```--recursive``` clone:

```bash

git clone --recursive git@github.com:dwcaraway/devmachine.git
```

Alternatively, if you've already cloned the repository, you can always checkout the submodules via:


```bash
git submodule update --init
```

## Synced Folders
Vagrant will attempt to sync the parent directory of the folder that it is stored in into your VM, assuming that you have a common
folder that you clone into. For example, if you clone into ```~/repos/devmachine```, within your vm, you can access the ```repos``` folder at ```~/repos```.

You'll need to add additional [Synced Folder](https://www.vagrantup.com/docs/synced-folders/) to your Vagrantfile in order to
have them mounted within the virtual machine.

Vagrant will automatically convert line endings for Windows<-->Unix host/guest situations.

## Provisioning
Run the following command to spin up a development virtual machine. If you have a suspended or halted virtual machine, ```up``` will start that machine but will not provision again.

```bash
vagrant up
```

If for any reason provisioning fails (e.g. network connectivity issue), you can rerun provisioning at any time without recreating your virtual machine while the VM is running using

```bash
vagrant provision
```

or using


```bash
vagrant up --provision
```

This runs ansible scripts to install all of the virtual machine dependencies. You can also run these playbooks within the virtual machine by

```
cd /vagrant/ansible
ansible-playbook -i hosts playbook.yml
```

## Logging In
The default username and password is ```vagrant```.

## Running the desktop
The centos 7 image has gnome desktop installed by default. A desktop is required for running, developing or testing any client-side code. To start Gnome, on the login prompt, start an X window session:

```bash
startx
```

** Note: ** Xwindow sessions must be started within virtualbox. A Babun or SSH shell will not support running xwindow sessions.

## Ending the Desktop Session
To end the session, simply log out. This will return you to a command prompt.

## SSH into the Virtual Machine
You may connect directly by clicking within the Virtualbox window. Additionally, you can connect via SSH using any supported client.

Run ssh to connect. *Windows Users* Windows has no native SSH support. You'll need to use an SSH client or *nix-like terminal such as [Babun](http://babun.github.io)

```bash
vagrant ssh
```

## Suspend the Virtual Machine
You may suspend the guest machine using [vagrant suspend](https://www.vagrantup.com/docs/cli/suspend.html).

```bash
vagrant suspend
```

Run ```vagrant up``` to start the virtual machine again.

## Shutting down
The virtual machine is shutdow by running [vagrant halt](https://www.vagrantup.com/docs/cli/halt.html).

```bash
vagrant halt
```

Run ```vagrant up``` to start the virtual machine again.

## Restarting
The virtual machine may have its power cycled by running [vagrant reload](https://www.vagrantup.com/docs/cli/reload.html). This is the equivalent of a ```halt``` followed by an ```up```. Reload is required for changing ports and other VM configuration activities.

```bash
vagrant reload
```

## Destroying
If you're done with a virtual machine, you may destroy it. All synced files will be retained but any virtual-machine only files will be destroyed. This process is non-reversible!

```bash
vagrant destroy
```

## Exporting
You may export the virtual machine to an image usable in virtualbox on other machines using the `vagrant package` command:

```bash
vagrant package
```
