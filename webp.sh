#!/bin/bash
set -eux

###############
# webpに変換する
###############

cd `dirname $0`

ffmpeg -r 30 -pattern_type glob -i 'screenshot_*.png' -loop 0 -r 10 output.webp
