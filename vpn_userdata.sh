#!/bin/bash
apt-get update
curl https://raw.githubusercontent.com/angristan/openvpn-install/80feebed16b3baa5979f764ee3272443f2fe08e6/openvpn-install.sh -o /tmp/openvpn-install.sh

chmod +x /tmp/openvpn-install.sh

APPROVE_INSTALL=y ENDPOINT=${PUBLIC_IP} APPROVE_IP=y IPV6_SUPPORT=n PORT_CHOICE=1 PROTOCOL_CHOICE=1 DNS=1 COMPRESSION_ENABLED=n  CUSTOMIZE_ENC=n CLIENT=${CLIENT} PASS=1 /tmp/openvpn-install.sh

# ovpn file is saved at /home/vpn/vpn.ovpn
