FROM docker:18-dind

MAINTAINER Sysdig

RUN apk --no-cache add curl bash
COPY inline_scan.sh /bin/inline_scan.sh
ENV DIND_RUN="true"

ENTRYPOINT ["/bin/inline_scan.sh"]
