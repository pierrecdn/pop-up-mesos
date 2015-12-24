# Cluster setup

echo 'Setting up the environment';
export LC_CTYPE=en_US.UTF-8

echo 'Copying files';
cp /vagrant/cluster/* ./

# workaround for vagrant-berkshelf bug
echo 'Downloading Vagrant box';
vagrant box add fgrehm/centos-6-64-lxc

echo 'Starting Vagrant';
vagrant up
