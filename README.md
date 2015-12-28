# Pop-Up Mesos

Spin up an isolated Mesos cluster in Vagrant using LXC and Chef.

## Overview

Pop-Up Mesos aims to provide a complete configurable Mesos cluster set up from Chef configured LXC virtual machines. The main goal is to build a complete environment from scratch using Chef so as to simulate as close as possible a real production environment (whether it is on bare metal or on top of cloud based virtual machines).

Considering LXC runs only inside Linux, the cluster is built inside a Debian Linux virtual machine. Both the outer and inner boxes are built using Vagrant.

## Outer box

The outer box is built with the VirtualBox provider, with a few customisations set up for network adapter performance (everything inside the ```config.vm.provider``` block). Please make sure you have 2 CPUs and 2GB of RAM to spare.

The box is provisioned with three bash scripts located inside ```scripts```:
* ```lxc.sh``` installs LXC deb packages and configures two virtual network bridges:
	* ```lxcbr0``` for host to guest communication (used by Vagrant for SSH access to the guests and for guest internet access). The dnsmasq DHCP server hands out addresses on this bridge.
	* ```virbr0``` for guest to guest communication (used by the Mesos cluster). The addresses have to be set up statically.
* ```pkg.sh``` installs ChefDK, Vagrant, the Vagrant LXC box, and Vagrant plugins. ChefDK, Vagrant, and the Vagrant LXC box may be put inside the ```pkgs``` directory where they will be mounted inside the virtual machine and installed. For proper package names and sources, please check the script.
* ```cup.sh``` copies the Vagrant cluster configuration from the mounted ```cluster``` directory to the home directory and runs ```vagrant up``` which will set up the Mesos cluster using ```vagrant-lxc``` and ```vagrant-berkshelf```.

## Inner boxes

The inner boxes are built from files inside the ```cluster``` directory:
* ```Berksfile``` is read by the ```vagrant-berkshelf``` plugin and used to source the cookbooks used by Chef.
* ```Vagrantfile``` builds the Mesos cluster using an LXC box. It builds an array of node hashes which are populated with the name, the static IP connected to the ```virbr0``` network bridge, the Chef run list, and attributes used by Chef cookbooks. The information is then applied inside the ```config.vm.define``` block. This block is called for each node.
