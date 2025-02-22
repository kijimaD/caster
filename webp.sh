#!/bin/bash
set -eux

###########################
# 今日の録画分をwebpに変換する
###########################

cd `dirname $0`

DATE=`date +%Y-%m-%d`
INPUT_DIR=photos/$DATE
OUTPUT=output/$DATE.webp

ffmpeg \
    -pattern_type glob -i "$INPUT_DIR/screenshot_*.png" \
    -r 30 \
    -q:v 50 -compression_level 6 \
    -loop 0 \
    -preset picture \
    -y \
    $OUTPUT
