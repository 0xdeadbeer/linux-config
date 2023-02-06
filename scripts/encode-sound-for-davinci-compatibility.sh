#!/usr/bin/bash

FILE=$1
ffmpeg -i "$1" -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le "${1%.*}-davinci-encoded.mov"
