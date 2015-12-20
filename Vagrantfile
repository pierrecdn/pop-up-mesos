#!/usr/bin/env ruby
# ^syntax detection

Vagrant.configure(2) do |config|
  config.vm.box = 'debian/jessie64'

  config.vm.provider 'virtualbox' do |v|
    v.cpus   = 2
    v.memory = 2048
    v.customize ['modifyvm', :id, '--nictype1', 'virtio']
    v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

  config.vm.provision 'lxc', type: 'shell', path: 'scripts/lxc.sh', privileged: true
  config.vm.provision 'pkg', type: 'shell', path: 'scripts/pkg.sh', privileged: false
  config.vm.provision 'cup', type: 'shell', path: 'scripts/cup.sh', privileged: false
end
