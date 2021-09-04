#!/bin/bash

# Cleanup
docker stop bionic &>/dev/null
docker rm bionic &>/dev/null
docker rmi myrepo:ubuntu &>/dev/null
rm -rf $(pwd)/ubuntu.tar

DOCKER_BUILDKIT=1 /usr/bin/docker build -t myrepo:ubuntu -o type=tar,dest=$(pwd)/ubuntu.tar -f Dockerfile.ubuntu .
echo building is done

set +x
docker import --change 'CMD /usr/sbin/nginx -g "daemon off;"' ./ubuntu.tar myrepo:ubuntu

docker run --name myrepo -p 8081:80 -d myrepo:ubuntu
