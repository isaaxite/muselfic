#!/bin/bash

TEMP_PATH="./tmp"
FORMAT=$1
INPUT_FILE_PATH="$2"
TEMP_INPUT_NAME="${TEMP_PATH}/i.$FORMAT"
TEMP_PURE_NAME="${TEMP_PATH}/p.$FORMAT"
ALBUM_COVER_PATH=$3
OUTPUT_FILE_PATH="${TEMP_PATH}/latest.$FORMAT"
FIXED_COVER_PATH="${TEMP_PATH}/fixed_cover.jpg"

# CURRENT_DIR=$(pwd)
# echo "当前工作目录: $CURRENT_DIR"

METADATA_TITLE="Album cover"
METADATA_COMMENT="Cover (front)"


# exec dir is /home/isaac/Music, valid
# cat "./muselfic/metadata/Divenire/temp.txt"
# invalid
# cat "./temp.txt"


rm -rf $TEMP_PATH
mkdir $TEMP_PATH
# echo "$INPUT_FILE_PATH $TEMP_INPUT_NAME"
cp "$INPUT_FILE_PATH" $TEMP_INPUT_NAME

echo "Removing the default cover of inputed media."

ffmpeg -i $TEMP_INPUT_NAME \
  -map 0:a -c copy \
  $TEMP_PURE_NAME

echo "-------------------------------------------"
echo "-------------------------------------------"
echo "-------------------------------------------"

# ffmpeg -i input.mp3 -i cover.jpg -map 0:a -map 1 -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" output.mp3
# ffmpeg -i $TEMP_PURE_NAME -i $ALBUM_COVER_PATH -map 0 -map 1 -c copy -c:v mjpeg -metadata:s:v title="$METADATA_TITLE" -metadata:s:v comment="$METADATA_COMMENT" "$OUTPUT_FILE_PATH"

# fix cover
# ffmpeg -i $ALBUM_COVER_PATH -c:v mjpeg $FIXED_COVER_PATH

# echo "-------------------------------------------"
# echo "-------------------------------------------"

# ffmpeg -i input.m4a -i cover.jpg -map 0 -map 1 -c copy -c:v mjpeg -disposition:v:0 attached_pic output.m4a
ffmpeg -i $TEMP_PURE_NAME -i $ALBUM_COVER_PATH \
  -map 0:a -map 1:v \
  -c copy -c:v:1 mjpeg \
  -disposition:v:0 attached_pic \
  "$OUTPUT_FILE_PATH"

# RETURN_CODE=$?

# if [ $RETURN_CODE -eq 0 ]; then
#   rm "$TEMP_INPUT_NAME" "$TEMP_PURE_NAME"
# fi
