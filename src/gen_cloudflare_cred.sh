#!/bin/sh
set -ex
echo "CF_EMAIL: ${CF_EMAIL}"
echo "CF_KEY: ${CF_KEY}"
cat >> cloudflare.ini <<EOF
# Cloudflare API credentials used by Certbot
dns_cloudflare_email = ${CF_EMAIL}
dns_cloudflare_api_key = ${CF_KEY}
EOF
