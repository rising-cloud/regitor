# Podman based registry on RHEL

1.   Installing the require packages like podman, skopeo, htpasswd etc...

```bash
sudo su - root 


yum install -y podman skopeo httpd-tools jq
```

2.   Prepare self sign certificates for registry

```bash
mkdir -p /opt/registry/certs


cd /opt/registry/certs


openssl req -newkey rsa:4096 -nodes -sha256 -keyout podmanRegistry.key -x509 -days 3650 -out / podmanRegistry.crt  -subj "/C=US/ST=NC/O=IBM/CN=ipas-pvm-144-042.purescale.raleigh.ibm.com"


cp  podmanRegistry.crt  /etc/pki/ca-trust/source/anchors/


update-ca-trust extract
```

3.   Create the htpasswd auth file.

```bash
mkdir -p /opt/registry/auth


htpasswd -bBc /opt/registry/auth/htpasswd <username> <user_password>
```

4. Start the registry container.
```bash

mkdir -p /opt/registry/data


podman run --name mirror-registry -p 5000:5000 -v /opt/registry/data:/var/lib/registry:z -v /opt/registry/auth:/auth:z -v /opt/registry/certs:/certs:z -e REGISTRY_AUTH=htpasswd -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/podmanRegistry.crt -e REGISTRY_HTTP_TLS_KEY=/certs/podmanRegistry.key  -d docker.io/library/registry:2
```

5.   Validate the registry is running properly.

```curl
curl -k https://ipas-pvm-144-042.purescale.raleigh.ibm.com:5000/v2/_catalog 

Output: 
{"repositories":[]}
```
