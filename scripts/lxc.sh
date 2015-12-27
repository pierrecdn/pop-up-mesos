#!/usr/bin/env bash
#
# LXC configuration
#
export DEBIAN_FRONTEND=noninteractive

echo 'Installing LXC packages';
apt-get -qq install lxc bridge-utils redir ethtool;

echo 'Writing LXC default configuration';
cat << EOF > /etc/lxc/default.conf
lxc.network.type  = veth
lxc.network.link  = lxcbr0
lxc.network.ipv4  = 0.0.0.0/24
lxc.network.flags = up
lxc.network.mtu   = 1500
EOF

echo 'Set up IP forwarding';
echo 1 > /proc/sys/net/ipv4/ip_forward;

echo 'Writing LXC network configuration';
cat << EOF > /etc/network/interfaces.d/lxc
auto lxcbr0
iface lxcbr0 inet static
  address 10.0.4.1
  netmask 255.255.255.0
  pre-up (ip addr show | grep lxcbr0) || brctl addbr lxcbr0
  post-up ethtool -K lxcbr0 tx off
  up iptables -t nat -A POSTROUTING -s 10.0.4.0/24 -o eth0 -j MASQUERADE
  down iptables -t nat -D POSTROUTING -s 10.0.4.0/24 -o eth0 -j MASQUERADE

auto virbr0
iface virbr0 inet static
  address 172.18.0.1
  netmask 255.255.0.0
  pre-up (ip addr show | grep virbr0) || brctl addbr virbr0
  post-up ethtool -K virbr0 tx off
EOF

echo 'Set up DHCP for containers';
apt-get install -qq dnsmasq
cat << EOF > /etc/dnsmasq.conf
interface=lxcbr0
dhcp-range=10.0.4.100,10.0.4.200,255.255.255.0,12h
EOF

echo 'Restart services';
ifup lxcbr0;
ifup virbr0; 
service dnsmasq restart;
