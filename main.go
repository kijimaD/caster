package main

import (
	"errors"
	"fmt"
	"os"
	"strings"
	"time"
)

const font = "resources/Jost-Regular.ttf"
const resolution = "960x540"

const timestampFormatGo = "2006-01-02T15-04-05"
const timeStampFormat = "%Y-%m-%dT%H-%M-%S"

// 2つごと割り当てられているので...
const vdev0 = "/dev/video0"
const vdev1 = "/dev/video2"
const vdev2 = "/dev/video4"
const vdev3 = "/dev/video6"

var (
	startDate = time.Now().Format(timestampFormatGo)
	outputDir = fmt.Sprintf("photos/%s", startDate)
	vdevs     = []string{vdev0, vdev1, vdev2, vdev3}
)

func main() {
	opts := []string{}
	opts = append(opts, "ffmpeg")

	// X11
	opts = append(opts, "-f", "x11grab", "-framerate", "1/2", "-i", ":0.0")
	// webcams
	devs, err := activeDevices(vdevs)
	if err != nil {
		panic(err)
	}
	for _, dev := range devs {
		opts = append(opts, "-f", "video4linux2", "-i", dev)
	}

	opts = append(opts, "-filter_complex", fmt.Sprintf(`"%s"`, buildFilterOpts(devs)))
	opts = append(opts, "-compression_level", "100")
	opts = append(opts, "-s", resolution)
	opts = append(opts, "-strftime", "1", fmt.Sprintf("%s/screenshot_%s.png", outputDir, timeStampFormat))

	fmt.Println(fmt.Sprintf("mkdir -p %s", outputDir))
	fmt.Println(strings.Join(opts, " "))
}

// 引数のデバイスで存在するものを返す
func activeDevices(devs []string) ([]string, error) {
	result := []string{}
	for _, dev := range devs {
		_, err := os.Stat(dev)
		if err != nil {
			if errors.Is(err, os.ErrNotExist) {
				continue
			}
			return []string{}, err
		}
		result = append(result, dev)
	}
	return result, nil
}

// 0:vがX11でオーバーレイのベース
func buildFilterOpts(devs []string) string {
	overlayOpts := []string{}
	for idx, _ := range devs {
		setting := fmt.Sprintf("[%d:v]scale=60:45[small%d];[small%d]scale=320:240[cam%d];[0:v][cam%d]overlay=W-w-10:H-h-%d", idx+1, idx+1, idx+1, idx+1, idx+1, (idx+1)*10)
		overlayOpts = append(overlayOpts, setting)
	}

	opts := []string{
		strings.Join(overlayOpts, ";"),
		fmt.Sprintf("drawtext=fontfile=%s: text='%%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10", font),
	}

	return strings.Join(opts, ",")
}
