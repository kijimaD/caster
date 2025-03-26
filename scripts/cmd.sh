#!/bin/bash
set -eux

#########################
# generated record script
# DO NOT EDIT
# $1: output pattern
#########################
ffmpeg -f x11grab -framerate 1/2 -i :0.0 -f video4linux2 -i /dev/video0 -filter_complex "[1:v]scale=320:240[cam1];[0:v][cam1]overlay=W-w-10:H-h-10-10,drawtext=fontfile=resources/Jost-Regular.ttf: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10" -compression_level 100 -s 960x540 -strftime 1 $1
