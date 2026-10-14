#!/bin/bash
set -e

echo "Starting SSH..."
exec /usr/sbin/sshd

#echo "Starting OpenVPN..."
#exec /usr/sbin/openvpn --config /etc/openvpn/server/server.conf
