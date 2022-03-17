# Regitor
Container registry installer and manager
- Install `Docker` based registry on linux systems
- Install `Podman` based registry on linux systems
- Install `Docker` based `quay.io` registry on linux systems
- Install `Podman` based `quay.io` registry on linux systems
- Registry on kubernetes.
- Registry cluster [HA and LB], system level cluster, volume level cluster.
- Sync registry, external to internal, many to one, multipla external registries to one insternal registry.
  - Cron sync, sync registry on perticuler time, user can enable or disable cron with simple cmd.
  - Manual sync, run some cmd to sync.
  - Event based [webhook]
  - Sync bindings or connections, Registry connection table to store registry details, `.dockerconfigjson`
  - Sync rules: wild card should work for all.
    - sync perticuler images, can add more filter like image with perticuler tag like latest, stable or may be with wildcard like :bvt*
    - sync org, all the images under perticuler folder
    - sync full registry[may be very lengthy job]

# Install
``` bash
python regitor-install.sh
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


