#!/bin/bash

ssh-keygen -R vpn-ca
ssh-copy-id -i ~/.ssh/vpn_ca_ed25519.pub root@vpn-ca

echo "Upload Req"
scp -i ~/.ssh/vpn_ca_ed25519 /root/easy-rsa/pki/reqs/server.req root@vpn-ca:/tmp


cd /root/easy-rsa
echo "Signing Req"
ssh -i ~/.ssh/vpn_ca_ed25519 root@vpn-ca 'cd /root/easy-rsa && ./easyrsa build-ca && ./easyrsa import-req /tmp/server.req server && ./easyrsa sign-req server server && exit'

echo "Download Certs"
scp -i ~/.ssh/vpn_ca_ed25519 root@vpn-ca:/root/easy-rsa/pki/issued/server.crt /tmp/server.crt
scp -i ~/.ssh/vpn_ca_ed25519 root@vpn-ca:/root/easy-rsa/pki/ca.crt /tmp/ca.crt

cp /tmp/{server.crt,ca.crt} /etc/openvpn/server/

echo "Start OPENVPN SERVER"
/usr/sbin/openvpn --config /etc/openvpn/server/server.conf --daemon 

