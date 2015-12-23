# ChefDK and Vagrant installation

chefdk='https://opscode-omnibus-packages.s3.amazonaws.com/debian/6/x86_64/chefdk_0.10.0-1_amd64.deb'
vagrant='https://releases.hashicorp.com/vagrant/1.8.0/vagrant_1.8.0_x86_64.deb'

echo 'Downloading packages';
wget --progress=bar:force -O chefdk.deb  $chefdk;
wget --progress=bar:force -O vagrant.deb $vagrant;

echo 'Installing packages';
sudo dpkg -i chefdk.deb;
sudo dpkg -i vagrant.deb;

echo 'Installing Vagrant plugins';
vagrant plugin install vagrant-lxc vagrant-berkshelf;
