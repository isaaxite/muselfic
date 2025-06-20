select_album() {
  RET_SELECTED_ALBUM_PATH=""
  local idx=0
  local arr=();
  for dir in data/*
  do
    local album_metadata_path="$dir/metadata.sh"
    . "$album_metadata_path"
    if [ -n "$METADATA_ALBUM" ]; then
      arr[$idx]=$dir
      echo "$idx - $METADATA_ALBUM: $dir"
      ((idx++))
    fi
  done
  read -p "Selected Index: " selected_idx
  RET_SELECTED_ALBUM_PATH="${arr[$selected_idx]}"
}

select_audio_dirpath() {
  RET_SELECT_AUDIO_DIRPATH=""
  local album_dirpath=$1
  local idx=0
  local arr=();

  for dir in $album_dirpath/*/
  do
    local audio_metadata_path="$dir/metadata.sh"

    . "$audio_metadata_path"
    if [ -n "$METADATA_TITLE" ]; then
      arr[$idx]=${dir:0:-1}
      echo "$idx - $METADATA_TITLE: ${arr[$idx]}"
      ((idx++))
    fi
  done
  read -p "Selected Index: " selected_idx
  RET_SELECT_AUDIO_DIRPATH="${arr[$selected_idx]}"
}

rm_temp_process_dist_dir() {
  if [ -d "$TEMP_PROCESS_DIST_DIR" ]; then
    rm -r "$TEMP_PROCESS_DIST_DIR"
  fi
}
