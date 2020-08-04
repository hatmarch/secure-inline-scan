FROM quay.io/containers/podman:v2.0.2

MAINTAINER SysdigDan <daniel.moloney@sysdig.com>

RUN useradd sysdig

RUN touch /etc/subgid /etc/subuid \
 && chmod g=u /etc/subgid /etc/subuid /etc/passwd \
 && echo sysdig:10000:65536 > /etc/subuid \
 && echo sysdig:0:65536 > /etc/subgid

RUN dnf install which curl bash podman -y \
 && dnf -y update \
 && dnf -y clean all \
 && rm -rf /var/cache /var/log/dnf* /var/log/yum.*

COPY inline_scan.sh /home/sysdig/inline_scan.sh

RUN chmod +x /home/sysdig/*

USER sysdig:sysdig
WORKDIR /home/sysdig
USER root
ENTRYPOINT ["/home/sysdig/inline_scan.sh"]
