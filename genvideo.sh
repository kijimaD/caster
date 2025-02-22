#!/bin/bash
set -eux

##########################
# 今日の録画分を動画に変換する
# 例...
# $ ./genvideo.sh 2025-02-22_22-04-23
##########################

cd `dirname $0`

# 変換元のディレクトリ名。通常はタイムスタンプが入る
target=$1

input_dir=photos/$target
output_base=output/$target
output_webp=$output_base.webp
output_webm=$output_base.webm

function exec()  {
    # 出力先
    target=$1

    ffmpeg \
        -pattern_type glob -i "$input_dir/screenshot_*.png" \
        -r 30 \
        -q:v 50 -compression_level 6 \
        -loop 0 \
        -preset picture \
        -y \
        $target
}

# 動画に変換する
exec $output_webp
exec $output_webm

# 画像用のメタデータを追加する
exiftool -CreateDate="`date +'%Y-%m-%d %H:%M:%S'`" -overwrite_original $output_webp
