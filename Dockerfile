FROM alpine:3.12

ENV FILEBOT_VER 4.9.2

RUN apk add --update --no-cache \
        openjdk11-jre-headless \
        p7zip \
        unrar \
        ffmpeg \
        chromaprint \
        mediainfo \
        zlib-dev

RUN mkdir /filebot \
  && cd /filebot \
  && wget "https://get.filebot.net/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.tar.xz" -O /filebot/filebot.tar>
  && tar -xJf filebot.tar.xz \
  && rm -rf filebot.tar.xz \

 # Fix filebot libs
 && ln -sf /lib/libz.so /filebot/lib/Linux-aarch64/libz.so \
 && ln -sf /usr/lib/libzen.so /filebot/lib/Linux-aarch64/libzen.so \
 && ln -sf /usr/lib/libmediainfo.so /filebot/lib/Linux-aarch64/libmediainfo.so \
 && rm -rf /filebot/lib/FreeBSD-amd64 /filebot/lib/Linux-armv7l /filebot/lib/Linux-x86_64 /filebot/lib/Linux-i686 \
 && chmod +x "/filebot/filebot.sh"

VOLUME /data

ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Dnet.filebot.archive.extractor=ShellExecutables -Duser.home=$HOME"

ENTRYPOINT ["/filebot/filebot.sh"]
