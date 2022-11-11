#!/bin/bash

image_name=cactusdynamics-linux-rt-builder
container_name=cactusdynamics-linux-rt-builder-${GITHUB_REF_NAME:-1} # In case this is running outside of Github CI.

set -x

docker build -f Dockerfile -t ${image_name} .

cleanup() {
  docker rm $container_name
  exit
}

trap cleanup EXIT INT TERM

docker run --name $container_name $image_name
docker cp $container_name:/workspace/debs .
cd debs
sha256sum *.deb > checksum.sha256sum
