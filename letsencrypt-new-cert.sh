#!/bin/sh

DOMAIN="$1"

# STAGING Test
#OUTPUT=$(docker run --rm --name certbot --network haproxy-net -e 9001:9001 -v letsencrypt:/etc/letsencrypt -v letsencrypt-logs:/var/log/letsencrypt certbot/certbot certonly --standalone --non-interactive --agree-tos --http-01-port=9001 --deploy-hook 'cat $RENEWED_LINEAGE/fullchain.pem $RENEWED_LINEAGE/privkey.pem > /etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem; chown root: "/etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem"; chmod 400 "/etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem"' --staging -d "$DOMAIN")

OUTPUT=$(docker run --rm --name certbot --network haproxy-net -e 9001:9001 -v letsencrypt:/etc/letsencrypt -v letsencrypt-logs:/var/log/letsencrypt certbot/certbot certonly --standalone --non-interactive --agree-tos --http-01-port=9001 --deploy-hook 'cat $RENEWED_LINEAGE/fullchain.pem $RENEWED_LINEAGE/privkey.pem > /etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem; chown root: "/etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem"; chmod 400 "/etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem"' -d "$DOMAIN")

if [[ $OUTPUT == *"Congratulations!"* ]]; then
    # reload haproxy
    docker kill -s SIGUSR2 haproxy
fi
