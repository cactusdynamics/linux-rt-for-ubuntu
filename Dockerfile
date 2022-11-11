FROM ubuntu:jammy

# This layer installs all the build dependencies.
RUN set -xe; \
    apt-get update; \
    apt-get install -y \
      bc \
      bison \
      build-essential \
      cpio \
      flex \
      git \
      kmod \
      libelf-dev \
      libncurses5-dev \
      libssl-dev \
      pahole \
      python3 \
      rsync \
      wget \
      zstd \
    ; \
    mkdir /workspace;

COPY build.sh /workspace/build.sh
COPY rt.config-fragment /workspace/rt.config-fragment

CMD /workspace/build.sh
