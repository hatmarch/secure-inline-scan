FROM quay.io/containers/podman:v2.0.2

MAINTAINER SysdigDan <daniel.moloney@sysdig.com>

# NOTE: Podman user already assigned to user 1000 and already
# has subgid and subuid setup

RUN dnf install which curl bash podman -y \
 && dnf -y update \
 && dnf -y clean all \
 && rm -rf /var/cache /var/log/dnf* /var/log/yum.*

RUN mkdir /scan && chgrp podman /scan

COPY inline_scan.sh /scan/inline_scan.sh

RUN chmod +x /scan/*

WORKDIR /scan

# Podman is user 1000
USER podman

ENTRYPOINT ["/scan/inline_scan.sh"]
