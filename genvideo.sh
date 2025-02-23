#!/bin/bash
set -eux

######################################################
# 指定録画ディレクトリをwebmとwebpに変換する
# 例...
# $ ./genvideo.sh 2025-02-22_22-04-23
# webmは閲覧用にする。保存容量の制約があるので粗くする
# webpは保存用にする。保存容量の制約がないのでそこまで粗くしない
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
    -r 30 \
    -q:v 100 -compression_level 6 \
    -b:v 1000k \
    -c:a libopus \
    -tile-columns 6 \
    -frame-parallel 1 \
    -row-mt 1 \
    -threads 16 \
    -loop 0 \
    -y \
    $output_webm

# webp
ffmpeg \
    -pattern_type glob -i "$input_dir/screenshot_*.png" \
    -r 30 \
    -q:v 50 -compression_level 6 \
    -tile-columns 6 \
    -frame-parallel 1 \
    -row-mt 1 \
    -threads 16 \
    -loop 0 \
    -preset picture \
    -y \
    $output_webp

# 画像用のメタデータを追加する
exiftool -CreateDate="`echo $target | sed -e "s/_/ /g"`" -overwrite_original $output_webp
