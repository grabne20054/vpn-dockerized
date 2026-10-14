from debian:trixie

USER root

RUN apt update && apt install -y easy-rsa openssh-server passwd nano

RUN echo 'root:changeme' | chpasswd && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config 

RUN ssh-keygen -t ed25519 -f ~/.ssh/vpn_service_ed25519 -N ""
RUN chmod 700 ~/.ssh/vpn_service_ed25519.pub

RUN mkdir /root/easy-rsa

WORKDIR /root/easy-rsa

RUN ln -s /usr/share/easy-rsa/* /root/easy-rsa/

RUN chmod 700 /root/easy-rsa

RUN cd /root/easy-rsa && ./easyrsa init-pki

RUN echo set_var EASYRSA_REQ_COUNTRY    "AUT" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_REQ_PROVINCE   "Styria" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_REQ_CITY       "Graz" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_REQ_ORG        "mgra" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_REQ_EMAIL      "mathiasstefangrabner@gmail.com" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_REQ_OU         "Community" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_ALGO           "ec" >> /root/easy-rsa/vars
RUN echo set_var EASYRSA_DIGEST         "sha512" >> /root/easy-rsa/vars

CMD ["/usr/sbin/sshd", "-D"]
