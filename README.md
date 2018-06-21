# Ipsec Ikev2 with letsencrypt certificate

This repo contains docker image that runs a ipsec ikev2 vpn with letsencrypt certificate for easy authentication

```
docker run --privileged=true --net=host --cap-add=ALL -v /lib/modules:/lib/modules -v $(pwd)/etc/ipsec.secrets:/usr/local/etc/ipsec.secrets --env-file dev.env.sample -it --rm ipsec_ikev2:latest bash
```
