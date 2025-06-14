select_album() {
  SELECTED_ALBUM_PATH=""
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
  SELECTED_ALBUM_PATH="${arr[$selected_idx]}"
}
