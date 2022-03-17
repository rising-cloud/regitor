# Regitor
Container registry installer and manager
- Install `Docker` based registry on Linux systems
- Install `Docker` based registry on **Windows** systems
- Install `Podman` based registry on Linux systems
- Install `Docker` based `quay.io` registry on Linux systems
- Install `Podman` based `quay.io` registry on Linux systems
- Registry on kubernetes.
- Registry cluster [HA and LB], system level cluster, volume level cluster.
- Sync registry, external to internal, many to one, multiple external registries to one internal registry.
  - Cron sync, sync registry on particular time, user can enable or disable cron with simple cmd.
  - Manual sync, run some cmd to sync.
  - Event based [webhook]
  - Sync bindings or **connections**, Registry connection table to store registry details, `.dockerconfigjson` in vault like `gopass`.
  - Sync rules: wild card should work for all.
    - sync particular images, can add more filter like image with particular tag like latest, stable or may be with wildcard like :bvt*
    - sync org, all the images under particular folder
    - sync full registry[may be very lengthy job]
  - Notification: send notification on mail, slack etc...
  - Manage fat manifest

# Install
``` bash
python regitor-install.sh
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
