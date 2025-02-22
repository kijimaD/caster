#!/bin/bash
set -eux

##########################
# 今日の録画分を動画に変換する
##########################

cd `dirname $0`

DATE=`date +%Y-%m-%d`
INPUT_DIR=photos/$DATE
OUTPUT_BASE=output/$DATE
OUTPUT_WEBP=$OUTPUT_BASE.webp
OUTPUT_WEBM=$OUTPUT_BASE.webm

function exec()  {
    # $1: 出力先

    ffmpeg \
        -pattern_type glob -i "$INPUT_DIR/screenshot_*.png" \
        -r 30 \
        -q:v 50 -compression_level 6 \
        -loop 0 \
        -preset picture \
        -y \
        $1
}

# 動画に変換する
exec $OUTPUT_WEBP
exec $OUTPUT_WEBM

# 画像用のメタデータを追加する
exiftool -CreateDate="`date +'%Y-%m-%d %H:%M:%S'`" -overwrite_original $OUTPUT_WEBP
