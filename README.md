## command

録画する。
```
ffmpeg -f x11grab -framerate 1/5 -i :0.0 -s 960x540 -vf "drawtext=fontfile=Jost-Black.ttf: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10" -strftime 1 "screenshot_%Y-%m-%d_%H-%M-%S.png"
```

アニメーションWebPに変換する。
```
ffmpeg -r 30 -pattern_type glob -i 'screenshot_*.png' -loop 0 -r 10 output.webp
```
