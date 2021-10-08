# Slft signed cert

## Cert creation
``` bash
echo "generateing a self signed certificate for run docker registry"

mkdir -p /opt/docker/certs/ && openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout /opt/docker/certs/dockerRegistry.key \
  -x509 -days 3650 -out /opt/docker/certs/dockerRegistry.crt
  
echo "copy the generated certificate to the certificate directory of the Docker host"

mkdir -p "/etc/docker/certs.d/${FULLHOSTNAME}" && cp /opt/docker/certs/dockerRegistry.crt $_
```
