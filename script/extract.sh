. script/util.sh

# avg1
extract_audio_to() {
  local avg1="$1"
  local avg2="$2"
  local avg3="$3"
  local input_audio_filepath=$avg1
  local output_audio_path=""

  # echo ""
  # echo "avg1: ${avg1:-none}"
  # echo "avg2: ${avg2:-none}"
  # echo "avg3: ${avg3:-none}"
  # echo ""

  if [ -z "$input_audio_filepath" ]; then
    echo "Miss input audio file path(e.g. \"./muselfic extract <audio filepath>\")!"
    exit 1
  fi

  if [ ! -f "$input_audio_filepath" ]; then
    echo "Input audio is not exist: $input_audio_filepath"
    exit 1
  fi

  if [ "$avg2" == "--dir" ] && [ -d "$avg3" ]; then
    output_audio_path=$avg3
  else
    select_album
    select_audio_dirpath $RET_SELECTED_ALBUM_PATH
    output_audio_path=$RET_SELECT_AUDIO_DIRPATH
    unset RET_SELECTED_ALBUM_PATH
    unset RET_SELECT_AUDIO_DIRPATH
  fi

  ffmpeg -i "$input_audio_filepath" -vn -acodec copy -map_metadata -1 "$output_audio_path/audio.mp3"
}
