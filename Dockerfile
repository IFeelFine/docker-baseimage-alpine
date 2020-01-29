FROM alpine:3.11

ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_RELEASE=https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz
ENV S6_OVERLAY_RELEASE=${S6_OVERLAY_RELEASE}
ENV PS1="[\u@\h \W]\$ "

LABEL build_version="ifeelfine.ca version:- ${VERSION} Build Date:- ${BUILD_DATE}"
LABEL maintainer="imdebating"

# Setup base filesystem

# Download s6 overlay
ADD ${S6_OVERLAY_RELEASE} /tmp/s6overlay.tar.gz

RUN echo . \
  # Base filesystem
  && tar xzf /tmp/s6overlay.tar.gz -C / \
  # Runtime pkgs
  && apk add --no-cache \
    bash \
    ca-certificates \
    coreutils \
    shadow \
    tzdata \
  # Create user
  && groupmod -g 1000 users \
  && useradd -u 1111 -U -d /config -s /bin/false abc \
  && usermod -G users abc \
  && mkdir -p \
    /config
    /defaults

ADD root /

RUN \
  rm  -rf \
    /root/.* \
    /root/* \
    /var/cache/apk/* \
    /tmp/* || exit 0

# Init
ENTRYPOINT [ "/init" ]