# Regitor
Container registry like docker registry installer and manager 

# Install
``` python
# python regitor-install.py
```
- install: to install the registry on local machine with default settings

### Valiables
| Variable  | shortcut | Description | require | default value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| base technology | b  | Docker, podman, quay.io | optional | Docker |
| Port  | p  | Deploy on which port | optional | 5000 |
| isSecure | s | Bool true:- tls and password, false:- no tls and optionally no password also | Optional | True |
| Authentication | a | Auth credentials, user and password using htpasswd | Optional | admin:admin |
| cert |  | if isSecure is true then use the cert for tls | Optional | create new slftsing cert and assign |
| Volume / Storage | v | specity volume for reg data, cert and auth file | Optional | provide locations. /opt/registry/data:/var/lib/registry:z, /opt/registry/auth:/auth:z, /opt/registry/certs:/certs:z | 
