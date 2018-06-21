FROM debian:9-slim

WORKDIR /app

ENV STRONGSWAN_VERSION 5.5.0
ENV GPG_KEY 948F158A4E76A27BF3D07532DF42C170B34DBA77
ENV BUILD_DEPS 'git gpg dirmngr make'


RUN apt-get update && apt-get install -y --no-install-recommends \
      kmod procps gcc iptables certbot libgmp3-dev curl ca-certificates gcc libc6-dev $BUILD_DEPS

RUN mkdir -p /usr/src/strongswan \
    && cd /usr/src \
    && curl -SOL "https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.gz.sig" \
    && curl -SOL "https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.gz" \
    && export GNUPGHOME="$(mktemp -d)" \
#    && gpg --keyserver hkp://pgp.mit.edu --recv-keys "$GPG_KEY" \
#    && gpg --batch --verify strongswan-$STRONGSWAN_VERSION.tar.gz.sig strongswan-$STRONGSWAN_VERSION.tar.gz \
    && tar -zxf strongswan-$STRONGSWAN_VERSION.tar.gz -C /usr/src/strongswan --strip-components 1 \
    && cd /usr/src/strongswan \
    && ./configure --enable-eap-identity --enable-eap-md5 --enable-eap-mschapv2 --enable-eap-tls --enable-eap-ttls --enable-eap-peap --enable-eap-tnc --enable-eap-dynamic --enable-eap-radius --enable-md4 \
    && make \
    && make install \
    && rm -rf "/usr/src/strongswan*" && \
    cd && \
    git clone https://github.com/certbot/certbot.git && \
    cd certbot/certbot-dns-cloudflare && \
    python setup.py install && \
    rm -rf certbot

RUN apt-get clean && \
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY src /app

EXPOSE 500/udp \
       4500/udp

#ENTRYPOINT ["/usr/sbin/ipsec"]
#CMD ["start", "--nofork"]
