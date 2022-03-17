# Regitor
Container registry installer and manager
- Install `Docker` based registry on Linux systems

# Install
``` bash
sh regitor.sh install
```
- install: to install the registry on local machine with default settings

### Valuables
| Variable  | shortcut | Description | require | default value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| base technology | b  | Docker, podman, quay.io | Optional | Docker |
| Port  | p  | Deploy on which port | Optional | 5000 |
| isSecure | s | Bool true:- tls and password, false:- no tls and optionally no password also | Optional | True |
| Authentication | a | Auth credentials, user and password using htpasswd | Optional | admin:admin |
| cert |  | if isSecure is true then use the cert for tls | Optional | create new slftsing cert and assign |
| Volume / Storage | v | specity volume for reg data, cert and auth file | Optional | provide locations. /opt/registry/data:/var/lib/registry:z, /opt/registry/auth:/auth:z, /opt/registry/certs:/certs:z | 
![image](https://user-images.githubusercontent.com/28144763/158745498-1c4515a6-930d-4c07-a959-62ee8a116ae6.png)
