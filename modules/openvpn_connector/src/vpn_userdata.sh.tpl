#!/bin/bash
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do sleep 1; done

apt update
apt install -y gpg curl
curl -fsSL https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub | gpg --dearmor | tee /etc/apt/trusted.gpg.d/openvpn-repo-pkg-keyring.gpg

DISTRO=$(lsb_release -c -s)
curl -fsSL https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-$DISTRO.list -o /etc/apt/sources.list.d/openvpn3.list

apt update
apt install -y python3-openvpn-connector-setup

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p

IF=$(ip route | grep -m 1 default | awk '{print $5}')
iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE
ip6tables -t nat -A POSTROUTING -o $IF -j MASQUERADE
DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent

# token in CloudConnexa 
# https://github.com/OpenVPN/openvpn-connector-setup
openvpn-connector-setup --token ${TOKEN}
