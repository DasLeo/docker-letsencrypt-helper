#!/bin/sh

OUTPUT=$(docker run --rm --name certbot --network haproxy-net -e 9001:9001 -v letsencrypt:/etc/letsencrypt -v letsencrypt-logs:/var/log/letsencrypt certbot/certbot renew --deploy-hook 'cat $RENEWED_LINEAGE/fullchain.pem $RENEWED_LINEAGE/privkey.pem > /etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem; chown root: "/etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem"; chmod 400 "/etc/letsencrypt/haproxy/$(basename $RENEWED_LINEAGE)-combined.pem"')

if [[ $OUTPUT != *"No renewals were attempted"* ]]; then
        # reload haproxy
        docker kill -s SIGUSR2 haproxy
fi
