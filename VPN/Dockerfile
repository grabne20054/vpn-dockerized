FROM debian:trixie-slim

USER root
CMD ["/bin/bash"]

RUN apt update && apt install -y openvpn easy-rsa openssh-server ufw passwd nano iproute2

RUN echo 'root:changeme' | chpasswd && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN ssh-keygen -t ed25519 -f ~/.ssh/vpn_ca_ed25519 -N ""
RUN chmod 700 ~/.ssh/vpn_ca_ed25519.pub

RUN mkdir /root/easy-rsa

WORKDIR /root/easy-rsa

RUN ln -s /usr/share/easy-rsa/* /root/easy-rsa/

RUN chmod 700 /root/easy-rsa
RUN echo set_var EASYRSA_ALGO "ec" >> vars
RUN echo set_var EASYRSA_DIGEST "sha512" >> vars

RUN ./easyrsa --batch init-pki

RUN ./easyrsa --batch gen-req server nopass

RUN cp pki/private/server.key /etc/openvpn/server/

RUN openvpn --genkey --secret /etc/openvpn/server/ta.key

# override config file from custom config file
COPY automate.sh ./automate.sh
RUN chmod +x ./automate.sh

COPY configs/server.conf /etc/openvpn/server/server.conf

COPY configs/base.conf /root/client-configs/base.conf

COPY make_config.sh ./
COPY configs/firewall-conf.sh /root/

# adjust networking

RUN echo net.ipv4.ip_forward = 1 > /etc/sysctl.conf

COPY configs/before.rules /etc/ufw/before.rules

# for netwoking into localnet
RUN iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE

RUN echo DEFAULT_FORWARD_POLICY="ACCEPT" > /etc/default/ufw

COPY configs/id_ed25519.pub /root/.ssh/id_ed25519.pub
COPY configs/id_ed25519 /root/.ssh/id_ed25519

#COPY start.sh /start.sh
#RUN chmod +x /start.sh
# start openvpn 
#ENTRYPOINT [ "/start.sh" ]
CMD ["/usr/sbin/sshd", "-D"]