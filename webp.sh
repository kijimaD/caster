#!/bin/bash
set -eux

###############
# webpに変換する
###############

cd `dirname $0`

INPUT_DIR=photos/`date +%Y-%m-%d`
OUTPUT=output/`date +%Y-%m-%d`.webp

ffmpeg \
    -pattern_type glob -i "$INPUT_DIR/screenshot_*.png" \
    -r 30 \
    -q:v 50 -compression_level 6 \
    -loop 0 \
    -preset picture \
    -y \
    $OUTPUT
