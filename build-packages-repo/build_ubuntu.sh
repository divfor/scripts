#!/bin/bash

# Cleanup
docker stop myrepo &>/dev/null
docker rm myrepo &>/dev/null
docker rmi myrepo:ubuntu &>/dev/null
rm -rf $(pwd)/ubuntu.tar &>/dev/null

DOCKER_BUILDKIT=1 docker build -t myrepo:ubuntu -o type=tar,dest=$(pwd)/ubuntu.tar -f Dockerfile.ubuntu .
echo building is done

set +x
docker import --change 'CMD /usr/sbin/nginx -g "daemon off;"' $(pwd)/ubuntu.tar myrepo:ubuntu

docker run --name myrepo -p 8081:80 -d myrepo:ubuntu
