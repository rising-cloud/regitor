# Regitor
Container registry installer and manager 

# Install
``` python
python regitor-install.py
```
- install: to install the registry on local machine with default settings

### Valiables
| Variable  | shortcut | Description | require | default value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| base technology | b  | Docker, podman, quay.io | Optional | Docker |
| Port  | p  | Deploy on which port | Optional | 5000 |
| isSecure | s | Bool true:- tls and password, false:- no tls and optionally no password also | Optional | True |
| Authentication | a | Auth credentials, user and password using htpasswd | Optional | admin:admin |
| cert |  | if isSecure is true then use the cert for tls | Optional | create new slftsing cert and assign |
| Volume / Storage | v | specity volume for reg data, cert and auth file | Optional | provide locations. /opt/registry/data:/var/lib/registry:z, /opt/registry/auth:/auth:z, /opt/registry/certs:/certs:z | 

## Cert creation
``` bash
echo "generate a certificate which will be used to run docker registry"
mkdir -p /opt/docker/certs/ && openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout /opt/docker/certs/dockerRegistry.key \
  -x509 -days 3650 -out /opt/docker/certs/dockerRegistry.crt
echo "copy the generated certificate to the certificate directory of the Docker host"
mkdir -p "/etc/docker/certs.d/${FULLHOSTNAME}" && cp /opt/docker/certs/dockerRegistry.crt $_
```
