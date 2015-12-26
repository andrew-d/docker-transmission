# docker-transmission

This repository contains a `Dockerfile` that builds an image with
[transmission][1] installed and ready for use.

This image is also an automated build on the Docker hub - you can fetch it
by running: `docker pull andrewd/transmission`

## Usage

Run with the following command line:

```
docker run \
    -e ADMIN_PASS=admin-password-goes-here \
    -p 12345:12345 \
    -p 12345:12345/udp \
    -p 127.0.0.1:9091:9091 \
    -v /local/path/to/downloads:/opt/transmission/downloads \
    -v /local/path/to/incomplete:/opt/transmission/incomplete \
    andrewd/transmission
```

You can control the running Transmission daemon using `transmission-remote`.

**WARNING**: The Transmission daemon does not whitelist the IP used to connect
to the RPC client, so you should not expose port 9091 to the internet.  It is
recommended that you expose it only to `localhost`, and, if required, use SSH
port forwarding or another method to access the daemon.

[1]: http://www.transmissionbt.com/
