#!/bin/bash
set -eux

###############
# webpに変換する
###############

cd `dirname $0`

ffmpeg \
    -pattern_type glob -i 'screenshot_*.png' \
    -r 30 \
    -q:v 50 -compression_level 6 \
    -loop 0 \
    -preset picture \
    output.webp
