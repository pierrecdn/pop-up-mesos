#!/usr/bin/env bash
#
# Cluster setup
#
echo 'Setting up the environment';
export LC_CTYPE=en_US.UTF-8

echo 'Copying configuration files';
cp /vagrant/cluster/* ./

echo 'Starting Vagrant';
vagrant up
