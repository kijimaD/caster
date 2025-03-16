package main

import (
	"fmt"
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
	fmt.Println(buildFilterOpts([]string{"testdata/video0", "testdata/video1"}))
}
