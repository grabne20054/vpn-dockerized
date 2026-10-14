#!/bin/bash

sudo docker swarm init

sudo docker network create --driver overlay vpn-nw

# join the swarm on other nodes (if any)
# sudo docker swarm join --token <SWARM_JOIN_TOKEN> <MANAGER_IP>:237
sudo docker volume create vpn-service-volume
sudo docker volume create vpn-ca-volume


sudo docker service create --name vpn-service --network vpn-nw -p 1195:1194/udp --cap-add=NET_ADMIN --mount type=bind,src=/dev/net/tun,dst=/dev/net/tun --replicas 1 vpn
sudo docker service create --name vpn-ca --network vpn-nw --replicas 1 vpn-ca

docker service update \
  --mount-add type=volume,source=vpn-service-volume,target=/root/easy-rsa \
  vpn-service

docker service update \
  --mount-add type=volume,source=vpn-ca-volume,target=/root/easy-rsa \
  vpn-ca