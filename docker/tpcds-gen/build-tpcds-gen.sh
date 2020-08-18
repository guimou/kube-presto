#!/bin/bash

set -e

BUILD_VER=338
REPO_NAME=quay.io/guimou

# Build docker image.
podman build --build-arg PRESTO_VERSION=$BUILD_VER \
	-t tpcds-gen-$BUILD_VER -f ./Dockerfile .

# Push to docker repository.
podman tag tpcds-gen-$BUILD_VER $REPO_NAME/tpcds-gen:$BUILD_VER
podman push $REPO_NAME/tpcds-gen:$BUILD_VER
