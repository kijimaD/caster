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
cd ../

# 変換元のディレクトリ名。通常はタイムスタンプが入る
target=$1

input_dir=photos/$target
output_base=output/$target
output_webp=$output_base.webp
output_webm=$output_base.webm

start_date=`echo $target | sed -E 's/.+?_([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}).+?/\1/'`
end_date=`ls $input_dir | sort -r | head -n 1 | sed -E 's/.+?_([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}).+?/\1/'`

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
    -metadata start_time="$start_date" \
    -metadata end_time="$end_date" \
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
