#!/bin/sh

metadata_rule=$1
metadata_opt=$2
DATA_DIRPATH="./data"

new_album() {
  local album_dirname=`uuidgen -x`
  local album_dirpath="$DATA_DIRPATH/$album_dirname"
  local album_metadata_filepath="$album_dirpath/metadata.sh"
  
  mkdir -p "$album_dirpath"

  echo "#[required] album name" > "$album_metadata_filepath"
  echo "METADATA_ALBUM=\"\"" >> "$album_metadata_filepath"

  echo "#[required] number" >> "$album_metadata_filepath"
  echo "METADATA_TOTAL_TRACKS=\"\"" >> "$album_metadata_filepath"

  echo "#[required]" >> "$album_metadata_filepath"
  echo "METADATA_ALBUM_ARTIST=\"\"" >> "$album_metadata_filepath"

  echo "#[required] genre[,genre0][,genre1][,...]" >> "$album_metadata_filepath"
  echo "METADATA_GENRE=\"\"" >> "$album_metadata_filepath"

  echo "#[required] yyyy/mm/dd" >> "$album_metadata_filepath"
  echo "METADATA_RELEASE_DATE=\"\"" >> "$album_metadata_filepath"

  echo "#[required] composer[,composer0][,composer1][,...]" >> "$album_metadata_filepath"
  echo "METADATA_COMPOSER=\"\"" >> "$album_metadata_filepath"
}

new_audio() {
  local album_dirpath=$1

  if [ ! -d "$album_dirpath" ]; then
    echo "Dirpath Not Exist!"
    exit 1
  fi

  local audio_dirname=`uuidgen -x`
  local audio_dirpath="$album_dirpath/$audio_dirname"
  local audio_metadata_filepath="$audio_dirpath/metadata.sh"

  mkdir -p "$audio_dirpath"

  echo "#[required] song name" > "$audio_metadata_filepath"
  echo "METADATA_TITLE=\"\"" >> "$audio_metadata_filepath"

  echo "#[required]" >> "$audio_metadata_filepath"
  echo "METADATA_ARTIST=\"\"" >> "$audio_metadata_filepath"

  echo "#[required] number" >> "$audio_metadata_filepath"
  echo "METADATA_TRACK_NUMBER=\"\"" >> "$audio_metadata_filepath"
}

if [ -z "$metadata_rule" ]; then
  echo "Miss rule between \"album\" or \"audio\""
  exit 1
fi

case $metadata_rule in
  ("album") new_album ;;
  ("audio") new_audio "$metadata_opt" ;;
  (*)
    echo "Wrong Rule!"
    exit 1
	;;
esac
