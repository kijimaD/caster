#!/bin/bash
set -eux

######################################################
# 指定録画ディレクトリをwebmとwebpに変換する
# 例...
# $ ./genvideo.sh 2025-02-22_22-04-23
# webmは閲覧用にする。保存容量の制約があるので粗くする
# webpは保存用にする。保存容量の制約がないのでそこまで粗くしない
#
# コーデックの参考
# https://trac.ffmpeg.org/wiki/Encode/VP9
# https://ffmpeg.org/ffmpeg-codecs.html#libwebp
######################################################

cd `dirname $0`

# 変換元のディレクトリ名。通常はタイムスタンプが入る
target=$1

input_dir=photos/$target
output_base=output/$target
output_webp=$output_base.webp
output_webm=$output_base.webm

# webm
ffmpeg \
    -pattern_type glob -i "$input_dir/screenshot_*.png" \
    -r 20 \
    -c:v libvpx-vp9 \
    -crf 50 -b:v 0 \
    -preset veryslow \
    -tile-columns 6 \
    -frame-parallel 1 \
    -row-mt 1 \
    -threads 16 \
    -vf hue=s=0 \
    -an \
    -sn \
    -y \
    $output_webm

# webp
ffmpeg \
    -pattern_type glob -i "$input_dir/screenshot_*.png" \
    -r 20 \
    -c:v libwebp \
    -q:v 10 \
    -compression_level 6 \
    -lossless 0 \
    -quality 10 \
    -tile-columns 6 \
    -frame-parallel 1 \
    -row-mt 1 \
    -threads 16 \
    -loop 0 \
    -preset text \
    -vf hue=s=0 \
    -y \
    $output_webp

# 画像用のメタデータを追加する
exiftool -CreateDate="`echo $target | sed -e "s/_/ /g"`" -overwrite_original $output_webp
