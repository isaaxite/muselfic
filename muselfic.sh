#!/bin/sh

is_direct_subpath() {
  local parent="${1%/}"
  local child="${2%/}"

  [[ "$child" == "$parent"/* ]] &&
  [[ "$child" != "$parent"/*/* ]] &&
  [[ "$parent" != "$child" ]]
}

# dist album
# avg1: <album dirpath>
# avg2: null
# dist multiple audios
# avg2...avgn: <audio dirpath> <audio dirpath> ...
dist_audios() {
  local album_dirpath="${1%/}"
  local output_dirpath="${2%/}"
  local audio_dirpath_list=""

  if [ ! -d "$album_dirpath" ]; then
    echo "Invalid album dirpath: ${album_dirpath:-null}"
    exit 1
  fi

  if [ ! -d "$output_dirpath" ]; then
    echo "Invalid output dirpath: ${output_dirpath:-null}"
    exit 1
  fi

  local album_metadata_filepath="$album_dirpath/metadata.sh"
  
  if [ ! -f "$album_metadata_filepath" ]; then
    echo "Album metadata file not exist!"
    exit 1
  fi

  shift 2
  local avg_rest="${@%/}"

  if [ -z "$avg_rest" ]; then
    audio_dirpath_list=("$album_dirpath"/*/)
    audio_dirpath_list="${audio_dirpath_list%/}"
  else
    local arr=()
    for audio_dirpath in $avg_rest
    do
      if [ ! -d "$audio_dirpath" ]; then
        echo "Invalid audio dirpath: ${audio_dirpath:-null}"
        continue
      fi

      if ! is_direct_subpath $album_dirpath $audio_dirpath; then
        echo "Current Audio do not belong to the Album"
        continue
      fi
      arr+=("$audio_dirpath")
    done
    audio_dirpath_list="${arr[*]}"
    unset arr
  fi

  local input_cover_filepath="$album_dirpath/cover.jpg"

  if [ ! -f "$input_cover_filepath" ]; then
    echo "Cover File Not Exist!"
    exit 1
  fi

  . "$album_metadata_filepath" 

  local invalid_audio_metadata_arr=()

  for audio_dirpath in $audio_dirpath_list
  do
    local audio_metadata_filepath="$audio_dirpath/metadata.sh"

    if [ ! -f "$audio_metadata_filepath" ]; then
      invalid_audio_metadata_arr+=("$audio_metadata_filepath")
      continue
    fi

    . "$audio_metadata_filepath"

    local input_audio_filepath="$audio_dirpath/input.mp3"
    local output_audio_filepath="$output_dirpath/$METADATA_ARTIST - $METADATA_TITLE.mp3"

    # 日期（date）的标准格式是：YYYY-MM-DD，曾使用的错误格式（YYYY/MM/DD）Amberol播放失败
    # 风格（genre）存在一个以上时，标准分隔符是 / 或半角分号（;）。目前使用了半角逗号，未见异常
    ffmpeg -i "$input_audio_filepath" -i "$input_cover_filepath" -c copy -map 0 -map 1 \
      -metadata title="$METADATA_TITLE" \
      -metadata artist="$METADATA_ARTIST" \
      -metadata album="$METADATA_ALBUM" \
      -metadata track="$METADATA_TOTAL_TRACKS/$METADATA_TRACK_NUMBER" \
      -metadata album_artist="$METADATA_ALBUM_ARTIST" \
      -metadata genre="$METADATA_GENRE" \
      -metadata date="$METADATA_RELEASE_DATE" \
      -metadata composer="$METADATA_COMPOSER" \
      "$output_audio_filepath"
  done
}

dist_album() {
  local album_dirpath="${1%/}"
  local output_dirpath="${2%/}"

  dist_audios $album_dirpath $output_dirpath
}

rule="$1"
shift

# dist multiple audio
# ./muselfic audio <album dirpath> <output dirpath> <audio dirpath 1> ... <audio dirpath n>
# dist album
# ./muselfic audio <album dirpath> <output dirpath>
case $rule in
  ("audio") dist_audios "$@";;
  ("album") dist_album "$@";;
  (*)
    echo "Expect the \"audio\" or \"album\" rule."
    exit 1
esac
