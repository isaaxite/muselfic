. script/global.sh

select_album() {
  RET_SELECTED_ALBUM_PATH=""
  local idx=0
  local arr=();
  for dir in $DATA_DIRPATH/*
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

multiple_select_album() {
  RET_SELECTED_ALBUM_PATH_ARR=()
  local idx=0
  local arr=();
  for dir in $DATA_DIRPATH/*
  do
    local album_metadata_path="$dir/metadata.sh"
    . "$album_metadata_path"
    if [ -n "$METADATA_ALBUM" ]; then
      arr[$idx]=$dir
      echo "$idx - $METADATA_ALBUM: $dir"
      ((idx++))
    fi
  done
  read -p "Selected Indexs(Separated by Space): " selected_idx_str
  # RET_SELECTED_ALBUM_PATH="${arr[$selected_idx]}"
  read -ra selected_idx_arr <<< "$selected_idx_str"
  for idx in "${selected_idx_arr[@]}"
  do
    RET_SELECTED_ALBUM_PATH_ARR+=("${arr[$idx]}")
  done
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

cp_album_2temp_process_dist_dir() {
  local album_dirpath=$1
  cp -r "$album_dirpath" "$TEMP_PROCESS_DIST_DIR"
}

gen_uuid() {
  echo `uuidgen -x`
}
