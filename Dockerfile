
FROM docker.io/nixm0nk3y/edgerouter-build-stretch:latest AS builder

LABEL maintainer="Nick Gregory <docker@openenterprise.co.uk>"

ARG UNBOUND_VERSION="1.25.1"
ARG UNBOUND_SHA256="0fe8b6277b0959cfd17562debac0aa5f71e0b02dc4ffa9c60271c583edab586f"

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y curl build-essential dh-autoreconf flex bison bc git pkg-config

RUN cd /tmp \
    && echo "==> Downloading Unbound..." \
    && curl -fSL https://nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz -o unbound-${UNBOUND_VERSION}.tar.gz \
    && echo "${UNBOUND_SHA256}  unbound-${UNBOUND_VERSION}.tar.gz" | sha256sum -c - \
    && tar xzf unbound-${UNBOUND_VERSION}.tar.gz \
    && cd /tmp/unbound-${UNBOUND_VERSION}

COPY ./debian /tmp/unbound-${UNBOUND_VERSION}/debian

RUN cd /tmp \
    && cp unbound-${UNBOUND_VERSION}.tar.gz unbound_${UNBOUND_VERSION}.orig.tar.gz \
    && cd /tmp/unbound-${UNBOUND_VERSION} \
    && apt-get install -y libssl-dev libevent-dev libexpat1-dev python python2.7-dev python2.7 swig \
    && dpkg-buildpackage -us -uc
