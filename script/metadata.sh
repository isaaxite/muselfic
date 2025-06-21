. script/global.sh
. script/util.sh

AVG="$1"
NEW_METADATA_TEMPLATE_CMD="${AVG:=none}"

# avg1: audio metadata filepath
# avg2: audio title
# avg3: audio artist
# avg4: audio track number
write_audio_metadata_template_to() {
  local audio_metadata_filepath=$1
  local title=$2
  local artist=$3
  local track_number=$4

  echo "#[required] song name" >> "$audio_metadata_filepath"
  echo "METADATA_TITLE=\"$title\"" >> "$audio_metadata_filepath"

  echo "#[required]" >> "$audio_metadata_filepath"
  echo "METADATA_ARTIST=\"$artist\"" >> "$audio_metadata_filepath"

  echo "#[required] number" >> "$audio_metadata_filepath"
  echo "METADATA_TRACK_NUMBER=\"$track_number\"" >> "$audio_metadata_filepath"
}

attach_audio_metadata_template_to() {
  local album_dirpath=$1
  local audio_dirname=$(gen_uuid)

  local audio_dirpath="$album_dirpath/$audio_dirname"
  local audio_metadata_filepath="$audio_dirpath/metadata.sh"

  mkdir -p "$audio_dirpath"
  touch "$audio_metadata_filepath"
  write_audio_metadata_template_to $audio_metadata_filepath

  echo ""
  echo "Audio Dirpath: $audio_dirpath"
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

  read -p "Title: " title
  read -p "Artist: " artist
  read -p "Track Number: " track_number

  write_audio_metadata_template_to \
    $AUDIO_METADATA_PAHT \
    $title \
    $artist \
    $track_number

  echo ""
  echo "Audio Dirpath: $AUDIO_DIR_PATH"
}

# avg1: filepath
# avg2: album name
# avg3: total tracks
# avg4: album artist
# avg5: genre
# avg6: release date
# avg7: composer
write_album_metadata_to() {
  local album_metadata_filepath=$1
  local album_name=$2
  local total_tracks=$3
  local album_artist=$4
  local genre=$5
  local release_date=$6
  local composer=$7

  echo "#[required] album name" >> "$album_metadata_filepath"
  echo "METADATA_ALBUM=\"$album_name\"" >> "$album_metadata_filepath"

  echo "#[required] number" >> "$album_metadata_filepath"
  echo "METADATA_TOTAL_TRACKS=\"$total_tracks\"" >> "$album_metadata_filepath"

  echo "#[required]" >> "$album_metadata_filepath"
  echo "METADATA_ALBUM_ARTIST=\"$album_artist\"" >> "$album_metadata_filepath"

  echo "#[required] genre[,genre0][,genre1][,...]" >> "$album_metadata_filepath"
  echo "METADATA_GENRE=\"$genre\"" >> "$album_metadata_filepath"

  echo "#[required] yyyy/mm/dd" >> "$album_metadata_filepath"
  echo "METADATA_RELEASE_DATA=\"$nam_release_date\"" >> "$album_metadata_filepath"

  echo "#[required] composer[,composer0][,composer1][,...]" >> "$album_metadata_filepath"
  echo "METADATA_COMPOSER=\"$composer\"" >> "$album_metadata_filepath"
}

new_album_metadata_template() {
  DATA_DIR_PATH="./data"
  ALBUM_NAME=`uuidgen -x`
  ALBUM_DIR_PATH="$DATA_DIR_PATH/$ALBUM_NAME"
  ALBUM_METADATA_PAHT="$ALBUM_DIR_PATH/metadata.sh"
  mkdir "$ALBUM_DIR_PATH"

  touch "$ALBUM_METADATA_PAHT"
  write_album_metadata_to $ALBUM_METADATA_PAHT

  echo ""
  echo "Album Dirpath: $ALBUM_DIR_PATH"
}

new_album_metadata() {
  local DATA_DIR_PATH="$DATA_DIRPATH"
  local ALBUM_NAME=$(gen_uuid)
  local ALBUM_DIR_PATH="$DATA_DIR_PATH/$ALBUM_NAME"
  local ALBUM_METADATA_PAHT="$ALBUM_DIR_PATH/metadata.sh"
  
  mkdir "$ALBUM_DIR_PATH"
  touch "$ALBUM_METADATA_PAHT"
  
  read -p "Album Name: " album_name
  read -p "Total Tracks: " total_tracks
  read -p "Album Artist: " album_artist
  read -p "Genre(<genre>[,genre0][,genre1][,...]): " genre
  read -p "Release Date(<yyyy | yyyy/mm/dd>): " release_date
  read -p "Composer(<composer>[,composer0][,composer1][,...]): " composer

  write_album_metadata_to \
    $ALBUM_METADATA_PAHT \
    $album_name \
    $total_tracks \
    $album_artist \
    $genre \
    $release_date \
    $composer

  echo ""
  echo "Album Dirpath: $ALBUM_DIR_PATH"
}

# cmd: ./muselfic.sh metadata album[ --template]
# subcmd: album
# subcmd: album --template
#
# cmd: ./muselfic.sh metadata audio[ --template]
# subcmd: audio
# subcmd: audio --template
#
# avg1: rule, <album | audio>
# avg2: option, [--template]
add_metadata_asset() {
  local avg1=$1
  local avg2=$2

  if [ -z "$avg1" ]; then
    echo "Miss rule between \"album\" or \"audio\""
    exit 1
  fi

  case $avg1 in
    ("album")
      if [ "$avg2" == "--template" ]; then
        new_album_metadata_template
      else
        new_album_metadata
      fi
      ;;
    ("audio")
      if [ "$avg2" == "--template" ]; then
        select_album
        local album_dirpath=$RET_SELECTED_ALBUM_PATH
        unset RET_SELECTED_ALBUM_PATH
        attach_audio_metadata_template_to $album_dirpath
      else
        select_album
        local album_dirpath=$RET_SELECTED_ALBUM_PATH
        unset RET_SELECTED_ALBUM_PATH
        attach_audio_metadata_to $album_dirpath
      fi
      ;;
    (*)
      echo "Wrong Rule!"
      exit 1
  esac
}

