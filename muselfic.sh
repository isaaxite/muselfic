#!/bin/sh
. script/global.sh
. script/util.sh

PROCESS_STEP="4"
DATA_DIR=""

TEMP_AVG_KEY=""
TEMP_AVG_VAL=""

# # -- start: set avg --
# is_key () {
#   # echo "exec is_key func"
#   if [[ "$1" == "--"* ]]; then
#     return 0
#   else
#     return 1
#   fi
# }

# set_avg() {
#   # echo "set avg, TEMP_AVG_KEY=$TEMP_AVG_KEY, TEMP_AVG_VAL=$TEMP_AVG_VAL"

#   if [ "$TEMP_AVG_KEY" == "--data-dir" ]; then
#     DATA_DIR="$TEMP_AVG_VAL"
#   fi

#   TEMP_AVG_KEY=""
#   TEMP_AVG_VAL=""
# }

# while [ "$#" -gt "0" ]
# do
#   if is_key $1; then
#     # echo "is key"
#     if [ -n "$TEMP_AVG_KEY" ]; then
#       # echo "set temp key name"
#       set_avg
#     fi
#     TEMP_AVG_KEY="$1"
#   else
#     # echo "is value"
#     TEMP_AVG_VAL="$1"
#   fi
#   shift
# done
# set_avg
# # -- end: set avg --

unprompt_dist_a_audio() {
  local audio_dir_path=$1
  local dist_dirpath=$2
  dist_dirpath=${dist_dirpath:="$DIST_DIRPATH"}

  # -- start: attached cover to pure audio --
  echo -e "\r\n[2/$PROCESS_STEP] Attaching cover to pure audio."

  local input_audio_path="${audio_dir_path}/audio.mp3"
  local output_audio_path="${audio_dir_path}/audio_with_cover.mp3"

  echo ""
  echo "Input Audio Path: $input_audio_path"
  echo "Output Audio Path: $output_audio_path"
  echo ""

  ffmpeg -i "$input_audio_path" -i "$TEMP_PROCESS_DIST_DIR/cover.jpg" -c copy -map 0 -map 1 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "$output_audio_path"
  # -- end: attched cover to pure audio --

  # -- start: attaching metadata to audio --
  echo -e "\r\n[3/$PROCESS_STEP] Attaching metadata to audio"
  . "${audio_dir_path}/metadata.sh"

  input_audio_path=$output_audio_path
  output_audio_path="${audio_dir_path}/${METADATA_ARTIST} - $METADATA_TITLE.mp3"
  
  echo ""
  echo "Input Audio Path: $input_audio_path"
  echo "Output Audio Path: $output_audio_path"
  echo "METADATA_TITLE: $METADATA_TITLE"
  echo "METADATA_ARTIST: $METADATA_ARTIST"
  echo "METADATA_ALBUM: $METADATA_ALBUM"
  echo "Track: $METADATA_TRACK_NUMBER/$METADATA_TOTAL_TRACKS"
  echo "METADATA_ALBUM_ARTIST: $METADATA_ALBUM_ARTIST"
  echo "METADATA_GENRE: $METADATA_GENRE"
  echo "METADATA_RELEASE_DATA: $METADATA_RELEASE_DATA"
  echo "METADATA_COMPOSER: $METADATA_COMPOSER"
  echo ""

  # exit 1

  ffmpeg -i "$input_audio_path" -metadata title="$METADATA_TITLE" \
    -metadata artist="$METADATA_ARTIST" \
    -metadata album="$METADATA_ALBUM" \
    -metadata track="$METADATA_TRACK_NUMBER/$METADATA_TOTAL_TRACKS" \
    -metadata album_artist="$METADATA_ALBUM_ARTIST" \
    -metadata genre="$METADATA_GENRE" \
    -metadata date="$METADATA_RELEASE_DATA" \
    -metadata composer="$METADATA_COMPOSER" \
    -c copy "$output_audio_path"
  # -- end: attaching metadata to audio --

  # -- start: moving latest audio to dist dir --
  echo -e "\r\n[4/$PROCESS_STEP] Moving [$output_audio_path] to [$dist_dirpath/]"
  mkdir -p "$dist_dirpath"
  mv "$output_audio_path" "$dist_dirpath"
  # -- start: moving latest audio to dist dir --
}

unprompt_dist_temp_album() {
  local dist_dirpath=$1
  dist_dirpath=${dist_dirpath:="$DIST_DIRPATH"}

  . "$TEMP_PROCESS_DIST_DIR/metadata.sh"
  for val in $TEMP_PROCESS_DIST_DIR/*/
  do
    local audio_dirpath=${val:0:-1}
    unprompt_dist_a_audio $audio_dirpath $dist_dirpath
  done
}

unprompt_dist_album() {
  local cur_album_dirpath=$1

  rm_temp_process_dist_dir

  cp -r "$cur_album_dirpath" "$TEMP_PROCESS_DIST_DIR"
   
}

dist_all() {
  local avg1="$1"
  local avg2="$2"
  local output_dirpath="$DIST_DIRPATH"

  if [ "$avg1" == "$OPT_OUTPUT_DIRPATH" ] && [ -n "$avg2" ]; then
    output_dirpath=$avg2
  fi

  for val in $DATA_DIRPATH/*/
  do
    local album_dirpath=${val:0:-1}
    unprompt_dist_album $album_dirpath
  done
}

dist_audio() {
  local avg1=$1
  local avg2=$2
  local avg3=$3
  local output_dirpath="$DIST_DIRPATH"

  cp2temp_dist_dir() {
    local selected_album_dirpath=$1
    local selected_audio_dirpath=$2

    rm_temp_process_dist_dir
    mkdir -p "$TEMP_PROCESS_DIST_DIR"
    cp "$selected_album_dirpath"/cover.* "$TEMP_PROCESS_DIST_DIR/"
    cp "${selected_album_dirpath}/metadata.sh" "$TEMP_PROCESS_DIST_DIR/"
    cp -r "$selected_audio_dirpath" "$TEMP_PROCESS_DIST_DIR/"
  }

  prompt_dist_temp_album() {
    local output_dirpath=$1
    select_album
    local selected_album_dirpath=$RET_SELECTED_ALBUM_PATH
    select_audio_dirpath $selected_album_dirpath
    local selected_audio_dirpath=$RET_SELECT_AUDIO_DIRPATH

    cp2temp_dist_dir $selected_album_dirpath $selected_audio_dirpath
    unprompt_dist_temp_album $output_dirpath
  }

  # cmd: ./muselfic dist audio
  # subcmd: ""
  if [ -z "$avg1" ]; then
    prompt_dist_temp_album $output_dirpath

  # cmd: ./muselfic dist audio --dir <output dirpath>
  # subcmd: --dir <output dirpath>
  elif [ "$avg1" == "$OPT_OUTPUT_DIRPATH" ]; then
    output_dirpath="$avg2"
    prompt_dist_temp_album $output_dirpath

  # cmd: ./muselfic dist audio <audio dirpath>[ --dir[ <output dirpath>]]
  # subcmd: <audio dirpath> --dir <output dirpath>
  else
    local audio_dirpath=$avg1
    local album_dirpath=$(dirname "$audio_dirpath")

    if [ "$avg2" == "$OPT_OUTPUT_DIRPATH" ] && [ -n "$avg3" ]; then
      output_dirpath="$avg3"
    fi

    cp2temp_dist_dir $album_dirpath $audio_dirpath
    unprompt_dist_temp_album $output_dirpath
  fi
}

dist_album() {
  local avg1=$1
  local avg2=$2
  local avg3=$3
  local output_dirpath="$DIST_DIRPATH"

  # echo ""
  # echo "avg1: ${avg1:-none}"
  # echo "avg2: ${avg2:-none}"
  # echo "avg3: ${avg3:-none}"
  # echo ""

  cp_album2temp_process_distpath() {
    local selected_album_dirpath=$1

    echo "$selected_album_dirpath"

    rm_temp_process_dist_dir

    cp -r "$selected_album_dirpath" "$TEMP_PROCESS_DIST_DIR"
  }

  prompt_temp_process_dist_dir(){
    local output_dirpath=$1

    select_album
    local selected_album_dirpath=$RET_SELECTED_ALBUM_PATH

    cp_album2temp_process_distpath $selected_album_dirpath
    unprompt_dist_temp_album $output_dirpath
    rm_temp_process_dist_dir
  }

  # cmd: ./muselfic.sh dist album
  # subcmd: ""
  if [ -z "$avg1" ]; then
    echo "./muselfic.sh dist album"
    prompt_temp_process_dist_dir $output_dirpath

  # cmd: ./muselfic.sh dist album --dir[ <output dir path>]
  # subcmd-1: --dir
  # subcmd-2: --dir <output dir path>
  elif [ "$avg1" == "$OPT_OUTPUT_DIRPATH" ]; then
    echo "./muselfic.sh dist album --dir[ <output dir path>]"
    output_dirpath="${avg2:=$DIST_DIRPATH}"
    prompt_temp_process_dist_dir $output_dirpath

  # cmd: ./muselfic.sh dist album <album path>[ --dir [<output dir path>]]
  # subcmd-1: <album path>
  # subcmd-2: <album path> --dir
  # subcmd-3: <album path> --dir <output dir path>
  else
    local album_dirpath="$avg1"
    if [ "$avg2" == "$OPT_OUTPUT_DIRPATH" ] && [ -n "$avg3" ]; then
      output_dirpath="$avg3"
    fi

    cp_album2temp_process_distpath $album_dirpath
    unprompt_dist_temp_album $output_dirpath
    rm_temp_process_dist_dir
  fi
}

dist_data() {
  local avg1=$1

  case $avg1 in
    ("album")
      shift
      dist_album $@;;
    ("audio")
      shift
      dist_audio $@;;
    ("")
      dist_all;;
    ("all")
      shift
      dist_all $@;;
    ("$OPT_OUTPUT_DIRPATH") dist_all $@;; 
    (*)
      echo "Wrong Option! \"./muselfic dist <option>\", You should type option between \"album\" or \"audio\" or \"all\" or \"\""
      exit 1;;
  esac
}

topest_avg1=$1
shift
case $topest_avg1 in
  ("dist") dist_data $@;;
  ("list") echo "list";;
  ("metadata") echo "metadata";;
  ("extract") echo "extract";;
  (*)
    echo "Wrong <rule>! You should type \"dist\" or \"list\" or \"metadata\" or \"extract\""
    exit 1
esac
