FROM --platform=linux/arm64 alpine:3.12
MAINTAINER Reinhard Pointner <rednoah@filebot.net>

ARG TARGETPLATFORM

ENV FILEBOT_VERSION 4.9.2
ENV FILEBOT_URL https://get.filebot.net/filebot/FileBot_$FILEBOT_VERSION/FileBot_$FILEBOT_VERSION-portable.tar.xz
ENV FILEBOT_SHA256 9f12000925b46c46fff1297174e07590e7a1c1e4eab670ad4bec3b4051559e41

ENV FILEBOT_HOME /opt/filebot

RUN apk add --update --no-cache \
#    p7zip \
#    unrar \
#   chromaprint \
   openjdk11 \
#   openjdk11-jre \
    zlib-dev 

RUN wget -O /filebot.tar.xz "$FILEBOT_URL" \
 && echo "$FILEBOT_SHA256 */filebot.tar.xz" | sha256sum -c - \
 && mkdir -p "$FILEBOT_HOME" \
 && tar --extract --file /filebot.tar.xz --directory "$FILEBOT_HOME" --verbose \
 && rm /filebot.tar.xz \
 
 # Fix filebot libs
 && ln -sf /lib/libz.so /opt/filebot/lib/Linux-aarch64/libz.so \
 && ln -sf /usr/lib/libzen.so /opt/filebot/lib/Linux-aarch64/libzen.so \
 && ln -sf /usr/lib/libmediainfo.so /opt/filebot/lib/Linux-aarch64/libmediainfo.so \
 && rm -rf /filebot/lib/FreeBSD-amd64 /opt/filebot/lib/Linux-armv7l /filebot/lib/Linux-x86_64 /filebot/lib/Linux-i686 \

RUN chmod +x "/opt/filebot/filebot.sh"
 
VOLUME /data
VOLUME /volume1

ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Dnet.filebot.archive.extractor=ShellExecutables -Duser.home=$HOME"

WORKDIR /volume1

ENTRYPOINT /opt/filebot/filebot.sh
