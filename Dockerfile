FROM ubuntu:25.04 AS runner

WORKDIR /work

RUN apt -y update && \
    apt -y install \
    # 撮影と動画生成
    ffmpeg \
    # 画像用に撮影時刻メタデータを付与するのに使う
    libimage-exiftool-perl

CMD /bin/sh
