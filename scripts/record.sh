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

./scripts/cmd.sh "$output_dir/screenshot_$timestamp.png"

end_date=`date +$timestamp`

./scripts/genvideo.sh $start_date $end_date
