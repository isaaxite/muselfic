#!/bin/sh

. script/util.sh

INPUT_AUDIO_PATH=$1

select_album
select_audio_dirpath $RET_SELECTED_ALBUM_PATH

ffmpeg -i "$INPUT_AUDIO_PATH" -vn -acodec copy -map_metadata -1 "${RET_SELECT_AUDIO_DIRPATH}audio.mp3"
