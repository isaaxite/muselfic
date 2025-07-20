#!/bin/sh

input_audio_filepath=$1
input_cover_filepath=$2
input_metadata_filepath=$3
output_dirpath=$4

. "$input_metadata_filepath"

ffmpeg -i "$input_audio_filepath" -i "$input_cover_filepath" -c copy -map 0 -map 1 \
	-metadata title="Last Summer Whisper" \
	-metadata artist="Anri" \
	-metadata album="Heaven Beach" \
	-metadata track="8/8" \
	-metadata album_artist="Anri" \
	-metadata genre="City Pop,J-Pop,AOR,Funk" \
	-metadata date="1982/07/21" \
	-metadata composer="Anri,Kunio Tago" \
	"$output_dirpath"
