#!/bin/sh

INPUT_AUDIO_PATH=$1
OUTPUT_AUDIO_DIR_PATH=$2

ffmpeg -i "$INPUT_AUDIO_PATH" -vn -acodec copy -map_metadata -1 "$OUTPUT_AUDIO_DIR_PATH/audio.mp3"
