#!/bin/bash
set -eux

##############
# 録画を開始する
##############

cd `dirname $0`

FONT=Jost-Regular.ttf
RESOLUTION=960x540
OUTPUT_DIR=photos/`date +%Y-%m-%d`

mkdir -p $OUTPUT_DIR

ffmpeg \
    -f x11grab \
    -framerate 1/5 \
    -i :0.0 \
    -s $RESOLUTION \
    -vf "drawtext=fontfile=$FONT: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10" \
    -strftime 1 "$OUTPUT_DIR/screenshot_%Y-%m-%d_%H-%M-%S.png"
