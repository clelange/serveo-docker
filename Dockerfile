FROM alpine:3.9

LABEL maintainer="Clemens Lange <clemens.lange@cern.ch>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
LABEL   org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.name="Alpine Linux container with ssh" \
        org.label-schema.description="Create tunnel to outside world" \
        org.label-schema.url="http://github.com/clelange" \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-url=$VCS_URL \
        org.label-schema.vendor="CERN" \
        org.label-schema.version=$VERSION \
        org.label-schema.schema-version="1.0"

RUN echo "@community http://dl-4.alpinelinux.org/alpine/v3.9/community/" >> /etc/apk/repositories \
	&& apk add --no-cache --update autossh@community \
	&& rm -rf /var/lib/apt/lists/* && \
    apk add --no-cache \
    bash openssh autossh && \
    adduser -h /home/serveo -D -u 6737 serveo && \
    mkdir -p /home/serveo/.ssh && \
    chown -R serveo /home/serveo/.ssh && \
    chmod 0700 /home/serveo/.ssh && \
    ssh-keyscan serveo.net > /home/serveo/.ssh/known_hosts

COPY --chown=serveo files /home/serveo/

USER serveo
ENV USER=serveo

ENTRYPOINT [ "/home/serveo/entrypoint.sh" ]

CMD ["autossh", "-M", "0", "-R", "80:localhost:80", "serveo.net"]