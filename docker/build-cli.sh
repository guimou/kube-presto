#!/bin/bash

set -e

BUILD_VER=338
REPO_NAME=quay.io/guimou

# Build docker image.
podman build --build-arg PRESTO_VERSION=$BUILD_VER \
	-t prestosql-cli-$BUILD_VER -f ./Dockerfile-presto-cli .

# Push to docker repository.
podman tag prestosql-cli-$BUILD_VER $REPO_NAME/prestosql-cli:$BUILD_VER
podman push $REPO_NAME/prestosql-cli:$BUILD_VER
