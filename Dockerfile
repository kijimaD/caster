FROM ubuntu:25.04 AS runner

WORKDIR /work

RUN apt -y update && \
    apt -y install \
    ffmpeg \
    libimage-exiftool-perl

CMD /bin/sh
