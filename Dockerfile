FROM quay.io/containers/podman:v2.0.2

MAINTAINER SysdigDan <daniel.moloney@sysdig.com>

RUN useradd sysdig

RUN touch /etc/subgid /etc/subuid \
 && chmod g=u /etc/subgid /etc/subuid /etc/passwd \
 && echo sysdig:10000:65536 > /etc/subuid \
 && echo sysdig:10000:65536 > /etc/subgid

# Use chroot since the default runc does not work when running rootless
# RUN echo "export BUILDAH_ISOLATION=chroot" >> /home/sysdig/.bashrc

# Use overlay graph driver
# RUN mkdir -p /home/sysdig/.config/containers \
#  && echo "driver=\"overlay\"" > /home/sysdig/.config/containers/storage.conf

RUN dnf install which curl bash nano wget podman -y \
 && dnf -y update \
 && rm -rf /var/cache /var/log/dnf* /var/log/yum.*

COPY inline_scan.sh /home/sysdig/inline_scan.sh

RUN chmod +x /home/sysdig/*

USER sysdig:sysdig
WORKDIR /home/sysdig

ENTRYPOINT ["/home/sysdig/inline_scan.sh"]
