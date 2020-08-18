#!/bin/bash

set -e

BUILD_VER=latest
REPO_NAME=quay.io/guimou

# Build docker image.
podman build \
	-t tpcds-run-$BUILD_VER -f ./Dockerfile .

# Push to docker repository.
podman tag tpcds-run-$BUILD_VER $REPO_NAME/tpcds-run:$BUILD_VER
podman push $REPO_NAME/tpcds-run:$BUILD_VER
