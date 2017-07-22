#!/bin/sh

REPO=muhifauzan/alpine-erlang
REFRESHED_AT=$(cat REFRESHED_AT)
ERLANG_VERSION=$(cat ERLANG_VERSION)

docker build \
       --force-rm \
       --build-arg REFRESHED_AT=$REFRESHED_AT \
       --build-arg ERLANG_VERSION=$ERLANG_VERSION \
       -t ${REPO}:${ERLANG_VERSION} \
       -t ${REPO}:latest \
       .

docker push ${REPO}:${ERLANG_VERSION}
docker push ${REPO}:latest
