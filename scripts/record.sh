#!/bin/bash
set -eux

############################
# 録画を開始する。停止後、変換する
############################

cd `dirname $0`
cd ../

font=resources/Jost-Regular.ttf
resolution=960x540
timestamp=%Y-%m-%dT%H-%M-%S

# ディレクトリは実行時に決定する
start_date=`date +$timestamp`
output_dir=photos/$start_date

mkdir -p $output_dir

ffmpeg \
    -f x11grab \
    -framerate 1/2 \
    -i :0.0 \
    -s $resolution \
    -vf "drawtext=fontfile=$font: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10" \
    -compression_level 100 \
    -strftime 1 "$output_dir/screenshot_$timestamp.png"

end_date=`date +$timestamp`

./scripts/genvideo.sh $start_date $end_date
