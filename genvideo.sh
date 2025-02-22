#!/bin/bash
set -eux

##########################
# 今日の録画分を動画に変換する
##########################

cd `dirname $0`

date=`date +%Y-%m-%d`
input_dir=photos/$date
output_base=output/$date
output_webp=$output_base.webp
output_webm=$output_base.webm

function exec()  {
    # $1: 出力先

    ffmpeg \
        -pattern_type glob -i "$input_dir/screenshot_*.png" \
        -r 30 \
        -q:v 50 -compression_level 6 \
        -loop 0 \
        -preset picture \
        -y \
        $1
}

# 動画に変換する
exec $output_webp
exec $output_webm

# 画像用のメタデータを追加する
exiftool -CreateDate="`date +'%Y-%m-%d %H:%M:%S'`" -overwrite_original $output_webp
