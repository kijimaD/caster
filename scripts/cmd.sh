#!/bin/bash
set -eux

#########################
# generated record script
# DO NOT EDIT
# $1: output pattern
#########################
ffmpeg -f x11grab -framerate 1/2 -i :0.0 -f video4linux2 -i /dev/video0 -f video4linux2 -i /dev/video2 -f video4linux2 -i /dev/video4 -filter_complex "[1:v]scale=60:45[small1];[small1]scale=320:240[cam1];[0:v][cam1]overlay=W-w-10:H-h-20-10[overlay1];[2:v]scale=60:45[small2];[small2]scale=320:240[cam2];[overlay1][cam2]overlay=W-w-10:H-h-20-h-20-10[overlay2];[3:v]scale=60:45[small3];[small3]scale=320:240[cam3];[overlay2][cam3]overlay=W-w-10:H-h-20-h-20-h-20-10,drawtext=fontfile=resources/Jost-Regular.ttf: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10" -compression_level 100 -s 960x540 -strftime 1 $1
