package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCameraDevices(t *testing.T) {
	devs, err := activeDevices([]string{
		"testdata/video0",
		"testdata/video1",
		"testdata/video2",
		"testdata/video3",
	})
	assert.NoError(t, err)
	assert.Equal(t, []string{"testdata/video0", "testdata/video1"}, devs)
}

func TestBuildFilterOpts(t *testing.T) {
	t.Run("デバイス数が2のとき組み立てられる", func(t *testing.T) {
		result := buildFilterOpts([]string{"testdata/video0", "testdata/video1"})
		expect := "[1:v]scale=60:45[small1];[small1]scale=320:240[cam1];[0:v][cam1]overlay=W-w-10:H-h-10-10[overlay1];[2:v]scale=60:45[small2];[small2]scale=320:240[cam2];[overlay1][cam2]overlay=W-w-10:H-h-10-h-10-10,drawtext=fontfile=resources/Jost-Regular.ttf: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10"
		assert.Equal(t, expect, result)
	})
	t.Run("デバイス数が0のとき組み立てられる", func(t *testing.T) {
		result := buildFilterOpts([]string{})
		expect := "drawtext=fontfile=resources/Jost-Regular.ttf: text='%{localtime}': fontcolor=white@1: fontsize=128: box=1: boxcolor=0x00000000@0.8: x=7: y=10"
		assert.Equal(t, expect, result)
	})
}
