. script/global.sh
. script/util.sh

append_album_path2list_str() {
  local album_dirpath="$1"
  local tree_tag="$2"
  . "$album_dirpath/metadata.sh"
  list_str+="$tree_tag ${YELLOW}${METADATA_ALBUM}${NC}: ${CYAN}${album_dirpath}${NC}${LINE_BREAK_CHARACTER}"
}

append_audio_path2list_str() {
  local item="$1"
  local tree_tag="$2"
  local audio_dirpath=${item:0:-1}
  . "$audio_dirpath/metadata.sh"
  list_str+="$tree_tag ${WHITE}${METADATA_TITLE}${NC}: ${BLUE}${audio_dirpath}${NC}${LINE_BREAK_CHARACTER}"
}

list_audio_path_data_of_album() {
  local album_dirpath="$1"
  local preffix_tree_tag="$2"
  local audio_dirpath_arr=($album_dirpath/*/)
  local audio_dirpath_arr_length=${#audio_dirpath_arr[@]}
  
  local idx=0
  while [ $idx -lt $((audio_dirpath_arr_length-1)) ]
  do
    append_audio_path2list_str "${audio_dirpath_arr[$idx]}" "$preffix_tree_tag $TREE_TAG_T"
    ((idx++))
  done
  append_audio_path2list_str "${audio_dirpath_arr[$idx]}" "$preffix_tree_tag $TREE_TAG_L"
}

list_album_path_data() {
  select_album
  local album_dirpath="$RET_SELECTED_ALBUM_PATH"
  unset RET_SELECTED_ALBUM_PATH

  append_album_path2list_str "${album_dirpath}"
  list_audio_path_data_of_album "${album_dirpath}"

  echo ""
  echo -e "$list_str"
}

list_all_path_data() {
  local album_dirpath_arr=($DATA_DIRPATH/*/)
  local album_dirpath_arr_length=${#album_dirpath_arr[@]}
  local idx=0
  
  while [ $idx -lt $((album_dirpath_arr_length-1)) ]
  do
    append_album_path2list_str "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_T"
    list_audio_path_data_of_album "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_I"
    ((idx++))
  done
  append_album_path2list_str "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_L"
  list_audio_path_data_of_album "${album_dirpath_arr[$idx]:0:-1}" " $FULL_WIDTH_SPACE"

  echo -e "$list_str"
}


list_path_data() {
  local avg1=$1

  if [ -z "$avg1" ]; then
    list_album_path_data
  elif [ "$avg1" == "--all" ]; then
    list_all_path_data
  else
    warning_echo "Wrong Option: \"$avg1\"! Except \"\" or \"--all\"";
    exit 1
  fi
}


append_album_detail2list_str() {
  local album_dirpath="$1"
  local root_tree_tag="$2"
  local sub_tree_tag="$3"
  
  . "$album_dirpath/metadata.sh"

  list_str+="$root_tree_tag ${CYAN}${album_dirpath}${NC}${LINE_BREAK_CHARACTER}"
  list_str+="$sub_tree_tag $TREE_TAG_T ${YELLOW}Album:${NC} $METADATA_ALBUM${LINE_BREAK_CHARACTER}"
  list_str+="$sub_tree_tag $TREE_TAG_T ${YELLOW}Total Tracks:${NC} $METADATA_TOTAL_TRACKS${LINE_BREAK_CHARACTER}"
  list_str+="$sub_tree_tag $TREE_TAG_T ${YELLOW}Album Artist:${NC} $METADATA_ALBUM_ARTIST${LINE_BREAK_CHARACTER}"
  list_str+="$sub_tree_tag $TREE_TAG_T ${YELLOW}Genre:${NC} $METADATA_GENRE${LINE_BREAK_CHARACTER}"
  list_str+="$sub_tree_tag $TREE_TAG_T ${YELLOW}Release Date:${NC} $METADATA_RELEASE_DATE${LINE_BREAK_CHARACTER}"
  list_str+="$sub_tree_tag $TREE_TAG_T ${YELLOW}Composer:${NC} $METADATA_COMPOSER${LINE_BREAK_CHARACTER}"
}

append_audio_detail2list_str() {
  local item="$1"
  local prefix_tree_tag="$2"
  local root_tree_tag="$3"
  local sub_tree_tag="$4"
  local audio_dirpath=${item:0:-1}
  
  . "$audio_dirpath/metadata.sh"

  list_str+="$prefix_tree_tag $root_tree_tag ${BLUE}${audio_dirpath}${NC}${LINE_BREAK_CHARACTER}"
  list_str+="$prefix_tree_tag $sub_tree_tag $TREE_TAG_T ${YELLOW}Title: ${NC}${METADATA_TITLE}${LINE_BREAK_CHARACTER}"
  list_str+="$prefix_tree_tag $sub_tree_tag $TREE_TAG_T ${YELLOW}Artist: ${NC}${METADATA_ARTIST}${LINE_BREAK_CHARACTER}"
  list_str+="$prefix_tree_tag $sub_tree_tag $TREE_TAG_L ${YELLOW}Track Number: ${NC}${METADATA_TRACK_NUMBER}${LINE_BREAK_CHARACTER}"
}

list_audio_detail_of_album() {
  local album_dirpath="$1"
  local prefix_tree_tag="$2"
  local audio_dirpath_arr=($album_dirpath/*/)
  local audio_dirpath_arr_length=${#audio_dirpath_arr[@]}
  
  local idx=0
  while [ $idx -lt $((audio_dirpath_arr_length-1)) ]
  do
    append_audio_detail2list_str \
      "${audio_dirpath_arr[$idx]}" \
      "$prefix_tree_tag" \
      "$TREE_TAG_T" \
      "$TREE_TAG_I"
    ((idx++))
  done
  append_audio_detail2list_str \
    "${audio_dirpath_arr[$idx]}" \
    "$prefix_tree_tag" \
    "$TREE_TAG_L" \
    " $FULL_WIDTH_SPACE"
}

list_album_detail() {
  select_album
  local album_dirpath="$RET_SELECTED_ALBUM_PATH"
  unset RET_SELECTED_ALBUM_PATH

  append_album_detail2list_str "${album_dirpath}"
  list_audio_detail_of_album "${album_dirpath}"

  echo ""
  echo -e "$list_str" 
}

list_all_detail() {
  local album_dirpath_arr=($DATA_DIRPATH/*/)
  local album_dirpath_arr_length=${#album_dirpath_arr[@]}
  local idx=0
  
  while [ $idx -lt $((album_dirpath_arr_length-1)) ]
  do
    append_album_detail2list_str "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_T" "$TREE_TAG_I"
    list_audio_detail_of_album "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_I"
    ((idx++))
  done
  append_album_detail2list_str "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_L" " $FULL_WIDTH_SPACE"
  list_audio_detail_of_album "${album_dirpath_arr[$idx]:0:-1}" " $FULL_WIDTH_SPACE"

  echo -e "$list_str"
}

list_detail() {
  local avg1=$1

  if [ -z "$avg1" ]; then
    list_album_detail
  elif [ "$avg1" == "--all" ]; then
    list_all_detail
  else
    warning_echo "Wrong Option: \"$avg1\"! Except \"\" or \"--all\"";
    exit 1
  fi
}

list_data() {
  local avg1="$1"

  case $avg1 in
    ("")
      list_detail ;;
    ("detail")
      shift
      list_detail "$@";;
    ("path")
      shift
      list_path_data "$@";;
    (*)
      warning_echo "Wrong Rule: \"$avg1\"! Except \"\" or \"path\" or \"detail\"";;
  esac

  unset list_str
}

