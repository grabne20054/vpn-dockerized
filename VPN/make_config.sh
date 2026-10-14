##!/bin/bash
 
# First argument: Client identifier
 
KEY_DIR=~/client-configs/keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf

mkdir -p ${OUTPUT_DIR}

CA_IP="vpn-ca"

# Generate Request
cd ~/easy-rsa
./easyrsa gen-req ${1} nopass

# COPY private key
mkdir -p ~/client-configs/keys/ 
cp pki/private/${1}.key ~/client-configs/keys/ 

# copy to ca server
scp -i ~/.ssh/vpn_ca_ed25519 ~/easy-rsa/pki/reqs/${1}.req root@${CA_IP}:/tmp

ssh -i ~/.ssh/vpn_ca_ed25519 root@${CA_IP} "cd ~/easy-rsa && ./easyrsa import-req /tmp/$1.req $1 && ./easyrsa sign-req client $1"

scp -i ~/.ssh/vpn_ca_ed25519 root@${CA_IP}:/root/easy-rsa/pki/issued/$1.crt /tmp

cp /tmp/$1.crt ~/client-configs/keys/
cp /etc/openvpn/server/ta.key ~/client-configs/keys/

cp /etc/openvpn/server/ca.crt ~/client-configs/keys/

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-crypt>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-crypt>') \
    > ${OUTPUT_DIR}/${1}.ovpn

echo ${OUTPUT_DIR}/${1}.ovpn