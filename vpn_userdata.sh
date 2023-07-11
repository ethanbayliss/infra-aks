#! /bin/bash
apt-get update
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/80feebed16b3baa5979f764ee3272443f2fe08e6/openvpn-install.sh

chmod +x openvpn-install.sh

APPROVE_INSTALL=y ENDPOINT=${ENDPOINT} APPROVE_IP=y IPV6_SUPPORT=n PORT_CHOICE=1 PROTOCOL_CHOICE=1 DNS=1 COMPRESSION_ENABLED=n  CUSTOMIZE_ENC=n CLIENT=${CLIENT} PASS=${PASS} ./openvpn-install.sh


