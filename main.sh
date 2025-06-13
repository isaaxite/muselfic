#!/bin/sh

PROCESS_STEP="4"
TEMP_DIR="./temp"
DATA_DIR=""

TEMP_AVG_KEY=""
TEMP_AVG_VAL=""

# -- start: set avg --
is_key () {
  # echo "exec is_key func"
  if [[ "$1" == "--"* ]]; then
    return 0
  else
    return 1
  fi
}

set_avg() {
  # echo "set avg, TEMP_AVG_KEY=$TEMP_AVG_KEY, TEMP_AVG_VAL=$TEMP_AVG_VAL"

  if [ "$TEMP_AVG_KEY" == "--data-dir" ]; then
    DATA_DIR="$TEMP_AVG_VAL"
  fi

  TEMP_AVG_KEY=""
  TEMP_AVG_VAL=""
}

while [ "$#" -gt "0" ]
do
  if is_key $1; then
    # echo "is key"
    if [ -n "$TEMP_AVG_KEY" ]; then
      # echo "set temp key name"
      set_avg
    fi
    TEMP_AVG_KEY="$1"
  else
    # echo "is value"
    TEMP_AVG_VAL="$1"
  fi
  shift
done
set_avg
# -- end: set avg --

# -- start: Copy audio data dir to temp dir --
echo -e "\r\n[1/$PROCESS_STEP] Copy audio data dir to temp dir."
if [ -d "$TEMP_DIR" ]; then
  rm -r "$TEMP_DIR"
fi

cp -r "$DATA_DIR" "$TEMP_DIR"
# -- end: Copy audio data dir to temp dir --


dist_a_audio() {
  audio_dir_path=$1
  echo "--$audio_dir_path"
  # -- start: attached cover to pure audio --
  echo -e "\r\n[2/$PROCESS_STEP] Attaching cover to pure audio."

  input_audio_path="${audio_dir_path}audio.mp3"
  output_audio_path="${audio_dir_path}audio_with_cover.mp3"

  echo ""
  echo "Input Audio Path: $input_audio_path"
  echo "Output Audio Path: $output_audio_path"
  echo ""

  ffmpeg -i "$input_audio_path" -i "$TEMP_DIR/cover.jpg" -c copy -map 0 -map 1 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "$output_audio_path"
  # -- end: attched cover to pure audio --

  # -- start: attaching metadata to audio --
  echo -e "\r\n[3/$PROCESS_STEP] Attaching metadata to audio"
  . "${audio_dir_path}metadata.sh"

  input_audio_path=$output_audio_path
  output_audio_path="${audio_dir_path}${METADATA_ARTIST} - $METADATA_TITLE.mp3"
  
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
  echo -e "\r\n[4/$PROCESS_STEP] Moving [$output_audio_path] to [dist/]"
  mkdir -p ./dist
  mv "$output_audio_path" ./dist
  rm -r "$TEMP_DIR"
  # -- start: moving latest audio to dist dir --
}

. "$TEMP_DIR/metadata.sh"
for album_dir in "$TEMP_DIR/*/"
do
  dist_a_audio $album_dir
done
