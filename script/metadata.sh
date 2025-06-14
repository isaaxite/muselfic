#!/bin/sh

AVG="$1"
NEW_METADATA_TEMPLATE_CMD="${AVG:=none}"

. script/util.sh

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

  echo ""
  read -p "Album dir path(e.g. data/<album>): " ALBUM_DIR_PATH

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

attach_audio_metadata_to() {
  AUDIO_DIR_NAME=`uuidgen -x`

  ALBUM_DIR_PATH=$1

  if [ -z $ALBUM_DIR_PATH ]; then
    exit 1
  fi

  AUDIO_DIR_PATH="$ALBUM_DIR_PATH/$AUDIO_DIR_NAME"
  AUDIO_METADATA_PAHT="$AUDIO_DIR_PATH/metadata.sh"

  mkdir -p "$AUDIO_DIR_PATH"
  touch "$AUDIO_METADATA_PAHT"

  read -p "Title: " aamt_title
  read -p "Artist: " aamt_artist
  read -p "Track Number: " aamt_track_number

  echo "#[required] song name" >> "$AUDIO_METADATA_PAHT"
  echo "METADATA_TITLE=\"$aamt_title\"" >> "$AUDIO_METADATA_PAHT"
  echo "#[required]" >> "$AUDIO_METADATA_PAHT"
  echo "METADATA_ARTIST=\"$aamt_artist\"" >> "$AUDIO_METADATA_PAHT"
  echo "#[required] number" >> "$AUDIO_METADATA_PAHT"
  echo "METADATA_TRACK_NUMBER=\"$aamt_track_number\"" >> "$AUDIO_METADATA_PAHT"
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

new_album_metadata() {
  DATA_DIR_PATH="./data"
  ALBUM_NAME=`uuidgen -x`
  ALBUM_DIR_PATH="$DATA_DIR_PATH/$ALBUM_NAME"
  ALBUM_METADATA_PAHT="$ALBUM_DIR_PATH/metadata.sh"
  mkdir "$ALBUM_DIR_PATH"

  touch "$ALBUM_METADATA_PAHT"
  
  read -p "Album Name: " nam_album_name
  read -p "Total Tracks: " nam_total_tracks
  read -p "Album Artist: " nam_album_artist
  read -p "Genre(<genre>[,genre0][,genre1][,...]): " nam_genre
  read -p "Release Date(<yyyy | yyyy/mm/dd>): " nam_release_date
  read -p "Composer(<composer>[,composer0][,composer1][,...]): " nam_composer

  echo "#[required] album name" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_ALBUM=\"$nam_album_name\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] number" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_TOTAL_TRACKS=\"$nam_total_tracks\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required]" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_ALBUM_ARTIST=\"$nam_album_artist\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] genre[,genre0][,genre1][,...]" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_GENRE=\"$nam_genre\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] yyyy/mm/dd" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_RELEASE_DATA=\"$nam_release_date\"" >> "$ALBUM_METADATA_PAHT"
  echo "#[required] composer[,composer0][,composer1][,...]" >> "$ALBUM_METADATA_PAHT"
  echo "METADATA_COMPOSER=\"$nam_composer\"" >> "$ALBUM_METADATA_PAHT"
}

if [ $NEW_METADATA_TEMPLATE_CMD == "--album-template" ]; then
  new_album_metadata_template
elif [ $NEW_METADATA_TEMPLATE_CMD == "--album" ]; then
  new_album_metadata
elif [ $NEW_METADATA_TEMPLATE_CMD == "--audio-template" ]; then
  list_album_dir
  attach_audio_metadata_template_to
elif [ $NEW_METADATA_TEMPLATE_CMD == "--audio" ]; then
  select_album
  attach_audio_metadata_to $SELECTED_ALBUM_PATH
elif [ $NEW_METADATA_TEMPLATE_CMD == "--test" ]; then
  select_album
  echo $SELECTED_ALBUM_PATH
else
  echo ""
  echo "--album: new a album metadata template to [data/<album>]"
  echo "--audio: new a audio metadata template to [data/<album>/<audio>]"
  exit 1;
fi
