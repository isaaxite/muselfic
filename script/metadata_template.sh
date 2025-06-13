#!/bin/sh

AVG="$1"
NEW_METADATA_TEMPLATE_CMD="${AVG:=none}"

list_album_dir() {
  echo "List of <Album Name>: <Album Dir Path>:"
  for dir in data/*
  do
    MD_ALBUM_METADATA_PATH="$dir/metadata.sh"
    . "$MD_ALBUM_METADATA_PATH"
    if [ -n "$METADATA_ALBUM" ]; then
      echo "- $METADATA_ALBUM: $dir"
    fi
  done
}

attach_audio_metadata_template_to() {
  AUDIO_DIR_NAME=`uuidgen -x`

  echo -e "Album dir path(e.g. data/<album>):"
  read ALBUM_DIR_PATH

  if [ -z $ALBUM_DIR_PATH ]; then
    exit 1
  fi

  AUDIO_DIR_PATH="$ALBUM_DIR_PATH/$AUDIO_DIR_NAME"
  AUDIO_METADATA_PAHT="$AUDIO_DIR_PATH/metadata.sh"

  mkdir -p "$AUDIO_DIR_PATH"
  touch "$AUDIO_METADATA_PAHT"
  echo "#[required] song name" >> "$AUDIO_METADATA_PAHT"
  echo "METADATA_TITLE=\"\"" >> "$AUDIO_METADATA_PAHT"
  echo "#[required]" >> "$AUDIO_METADATA_PAHT"
  echo "METADATA_ARTIST=\"\"" >> "$AUDIO_METADATA_PAHT"
  echo "#[required] number" >> "$AUDIO_METADATA_PAHT"
  echo "METADATA_TRACK_NUMBER=\"\"" >> "$AUDIO_METADATA_PAHT"
}

new_album_metadata_template() {
  DATA_DIR_PATH="./data"
  ALBUM_NAME=`uuidgen -x`
  ALBUM_DIR_PATH="$DATA_DIR_PATH/$ALBUM_NAME"
  ALBUM_METADATA_PAHT="$ALBUM_DIR_PATH/metadata.sh"
  mkdir "$ALBUM_DIR_PATH"

  touch "$ALBUM_METADATA_PAHT"
  echo "#[required] album name" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_ALBUM=\"\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] number" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_TOTAL_TRACKS=\"\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required]" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_ALBUM_ARTIST=\"\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] genre[,genre0][,genre1][,...]" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_GENRE=\"\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] yyyy/mm/dd" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_RELEASE_DATA=\"\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] composer[,composer0][,composer1][,...]" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_COMPOSER=\"\"" >> "$ALBUM_METADATA_PAHT"
}

if [ $NEW_METADATA_TEMPLATE_CMD == "--album" ]; then
  new_album_metadata_template
elif [ $NEW_METADATA_TEMPLATE_CMD == "--audio" ]; then
  list_album_dir
  attach_audio_metadata_template_to
else
  echo ""
  echo "--album: new a album metadata template to [data/<album>]"
  echo "--audio: new a audio metadata template to [data/<album>/<audio>]"
  exit 1;
fi
