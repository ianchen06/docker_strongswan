#!/bin/sh
set -ex
sh ./gen_cloudflare_cred.sh
sh ./get_cert.sh
iptables -t nat -A POSTROUTING -s $VPN_SUBNET -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1

cat >> /usr/local/etc/ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file
# basic configuration
config setup
    strictcrlpolicy=no
    uniqueids = no
    charondebug = ike 2, cfg 2

conn %default
    dpdaction=clear
    dpddelay=35s
    dpdtimeout=2000s

    keyexchange=ikev2
    auto=add
    rekey=no
    reauth=no
    fragmentation=yes
    compress=yes

    ### left - local (server) side
    # filename of certificate chain located in /etc/strongswan/ipsec.d/certs/
    leftcert=fullchain.pem
    leftsendcert=always
    leftsubnet=0.0.0.0/0,::/0

    ### right - remote (client) side
    eap_identity=%identity
    rightsourceip=${VPN_SUBNET}
    rightdns=8.8.8.8

conn ikev2-mschapv2
    rightauth=eap-mschapv2

conn ikev2-mschapv2-apple
    rightauth=eap-mschapv2
    leftid=${VPN_DOMAIN}
EOF
exec ipsec start --nofork
