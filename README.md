# docker-letsencrypt-helper
Helper scripts to use Letsencrypt inside Docker with HAProxy

## Requirements

- Docker volume for certificates named ```letsencrypt```
- Docker volume for certbot logs named ```letsencrypt-logs```
- HAProxy Docker Container
  - ACLs to pass ```/.well-known/acme-challenge/``` to the hostname ```certbot``` on port 9001
  - Utilizing the volume ```letsencrypt:/usr/local/etc/haproxy/certs``` with folder ```haproxy``` inside
  - Using Dockers DNS server to resolve hostnames in certbot backend

## HAProxy setup

Set the following in ```haproxy.cfg```

```
gobal
...
	crt-base /usr/local/etc/haproxy/certs/haproxy
...
resolvers docker-dns
	nameserver docker 127.0.0.11:53
	resolve_retries 3
	timeout resolve 1s
	timeout retry   1s
...
frontend http
	bind *:80
	bind *:443 ssl crt /usr/local/etc/haproxy/certs/haproxy/ alpn h2,http/1.1
	# ACLs
	acl letsencrypt-acl path_beg /.well-known/acme-challenge/
	redirect scheme https if !{ ssl_fc } !letsencrypt-acl
	use_backend certbot if letsencrypt-acl
...
backend certbot
	server certbot certbot:9001 resolvers docker-dns init-addr libc,none
```
