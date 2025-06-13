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

# -- start: attached cover to pure audio --
echo -e "\r\n[2/$PROCESS_STEP] Attaching cover to pure audio."
ffmpeg -i "$TEMP_DIR/audio.mp3" -i "$TEMP_DIR/cover.jpg" -c copy -map 0 -map 1 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "$TEMP_DIR/audio_with_cover.mp3"
# -- end: attched cover to pure audio --

# -- start: attaching metadata to audio --
echo -e "\r\n[3/$PROCESS_STEP] Attaching metadata to audio"
. "$TEMP_DIR/metadata.sh"
ffmpeg -i "$TEMP_DIR/audio_with_cover.mp3" -metadata title="$METADATA_TITLE" \
  -metadata artist="$METADATA_ARTIST" \
  -metadata album="$METADATA_ALBUM" \
  -metadata track="$METADATA_TRACK_NUMBER/$METADATA_TOTAL_TRACKS" \
  -metadata album_artist="$METADATA_ALBUM_ARTIST" \
  -metadata genre="$METADATA_GENRE" \
  -metadata date="$METADATA_RELEASE_DATA" \
  -metadata composer="$METADATA_COMPOSER" \
  -c copy "$TEMP_DIR/$METADATA_ARTIST - $METADATA_TITLE.mp3"
# -- end: attaching metadata to audio --

# -- start: moving latest audio to dist dir --
echo -e "\r\n[4/$PROCESS_STEP] Moving [$METADATA_ARTIST - $METADATA_TITLE.mp3] to [dist/]"
LAST_AUDIO_PATH="$TEMP_DIR/$METADATA_ARTIST - $METADATA_TITLE.mp3"
mkdir -p ./dist
mv "$LAST_AUDIO_PATH" ./dist
rm -r "$TEMP_DIR"
# -- start: moving latest audio to dist dir --
