
FROM docker.io/nixm0nk3y/edgerouter-build-stretch:latest AS builder

LABEL maintainer="Nick Gregory <docker@openenterprise.co.uk>"

ARG UNBOUND_VERSION="1.10.0"
ARG UNBOUND_SHA256="152f486578242fe5c36e89995d0440b78d64c05123990aae16246b7f776ce955"

RUN apt-get update \
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
