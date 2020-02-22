# docker-letsencrypt-helper
Helper scripts to use Letsencrypt inside Docker with HAProxy

## Requirements

- Docker volume for certificates named ```letsencrypt```
- Docker volume for certbot logs named ```letsencrypt-logs```
- HAProxy Docker Container
  - ACLs to pass ```/.well-known/acme-challenge/``` to the hostname ```certbot``` on port 9001
  - Utilizing the "letsencrypt" volume with the folder ```/haproxy``` on it's frontend
  - Using Dockers DNS server to resolve hostnames in certbot backend

## HAProxy setup

