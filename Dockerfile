FROM alpine:3.6

ARG REFRESHED_AT
ARG ERLANG_VERSION

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=$REFRESHED_AT \
    LANG=en_US.UTF-8 \
    HOME=/opt/app \
    ERLANG_VERSION=$ERLANG_VERSION \
    # Set this so that CTRL+G works properly
    TERM=xterm

WORKDIR /tmp/erlang-build

# Create default user and home directory, set owner to default
RUN mkdir -p $HOME && \
    adduser -s /bin/sh -u 1001 -G root -h $HOME -S -D default && \
    chown -R 1001:0 $HOME && \
    # Add edge repos tagged so that we can selectively install edge packages
    echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk --update upgrade --no-cache && \
    # Install Erlang/OTP deps
    apk add --no-cache pcre@edge \
      ca-certificates \
      openssl-dev \
      ncurses-dev \
      unixodbc-dev \
      zlib-dev \
      openssh \
      git && \
    # Install Erlang/OTP build deps
    apk add --no-cache --virtual .erlang-build \
      autoconf \
      build-base \
      perl-dev && \
    # Shallow clone Erlang/OTP
    git clone -b OTP-${ERLANG_VERSION} --single-branch --depth 1 https://github.com/erlang/otp.git . && \
    # Erlang/OTP build env
    export ERL_TOP=/tmp/erlang-build && \
    export PATH=${ERL_TOP}/bin:${PATH} && \
    export CPPFlAGS="-D_BSD_SOURCE ${CPPFLAGS}" && \
    # Configure
    ./otp_build autoconf && \
    ./configure --prefix=/usr \
      --sysconfdir=/etc \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --without-javac \
      --without-wx \
      --without-debugger \
      --without-observer \
      --without-jinterface \
      --without-cosEvent\
      --without-cosEventDomain \
      --without-cosFileTransfer \
      --without-cosNotification \
      --without-cosProperty \
      --without-cosTime \
      --without-cosTransactions \
      --without-et \
      --without-gs \
      --without-ic \
      --without-megaco \
      --without-orber \
      --without-percept \
      --without-typer \
      --enable-threads \
      --enable-shared-zlib \
      --enable-ssl=dynamic-ssl-lib \
      --enable-hipe && \
    make -j4 && make install && \
    # Cleanup
    cd $HOME && \
    rm -rf /tmp/erlang-build && \
    apk del --force .erlang-build && \
    # Update ca certificates
    update-ca-certificates --fresh

WORKDIR $HOME

CMD ["/bin/sh"]
