#!/usr/bin/env bash
#
# Install Debian packages
#
declare -A url sum
# shellcheck disable=SC2154
url[chefdk]='https://opscode-omnibus-packages.s3.amazonaws.com/debian/6/x86_64/chefdk_0.10.0-1_amd64.deb'
sum[chefdk]='8017b195105b5f2fcd248c38311561294f7ff91b64a491d64a4286ce9cf1a71d'
# shellcheck disable=SC2154
url[vagrant]='https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb'
sum[vagrant]='ed0e1ae0f35aecd47e0b3dfb486a230984a08ceda3b371486add4d42714a693d'

for pkg in "${!sum[@]}"
do
  if ! echo "${sum[$pkg]} /vagrant/pkgs/${url[$pkg]##*/}" | sha256sum -c; then
    echo "Checksum failed, downloading $pkg from ${url[$pkg]}"
    curl --create-dirs -sS -C - -o /vagrant/pkgs/${url[$pkg]##*/} "${url[$pkg]}"
  fi
  sudo dpkg -i /vagrant/pkgs/${url[$pkg]##*/}
done
#
# Install Vagrant box
#
echo 'Installing Vagrant box';
if ! vagrant box add '/vagrant/pkgs/lxc.box' --name 'fgrehm/centos-6-64-lxc'; then
  vagrant box add fgrehm/centos-6-64-lxc
fi
#
# Install Vagrant plugins
#
echo 'Installing Vagrant plugins';
vagrant plugin install vagrant-lxc vagrant-berkshelf
