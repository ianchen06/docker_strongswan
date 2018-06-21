#!/bin/sh
set -ex
echo "VPN_DOMAIN is $VPN_DOMAIN"
certbot certonly --server https://acme-v02.api.letsencrypt.org/directory --rsa-key-size 4096 --dns-cloudflare --dns-cloudflare-credentials cloudflare.ini --register-unsafely-without-email --agree-tos -d $VPN_DOMAIN

# For testing
#certbot certonly --server https://acme-staging-v02.api.letsencrypt.org/directory --rsa-key-size 4096 --dns-cloudflare --dns-cloudflare-credentials cloudflare.ini --register-unsafely-without-email --agree-tos -d $VPN_DOMAIN

ln -s /etc/letsencrypt/live/${VPN_DOMAIN}/fullchain.pem /usr/local/etc/ipsec.d/certs/fullchain.pem
ln -s /etc/letsencrypt/live/${VPN_DOMAIN}/privkey.pem /usr/local/etc/ipsec.d/private/privkey.pem
