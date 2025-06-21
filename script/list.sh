. script/global.sh
. script/util.sh

list_data() {
  local avg1="$1"
  local list_str=""

  append_album_data2list_str() {
    local album_dirpath="$1"
    local tree_tag="$2"
    . "$album_dirpath/metadata.sh"
    list_str+="$tree_tag ${YELLOW}${METADATA_ALBUM}${NC}: ${CYAN}${album_dirpath}${NC}${LINE_BREAK_CHARACTER}"
  }

  append_audio_data2list_str() {
    local item="$1"
    local tree_tag="$2"
    local audio_dirpath=${item:0:-1}
    . "$audio_dirpath/metadata.sh"
    list_str+="$tree_tag ${WHITE}${METADATA_TITLE}${NC}: ${BLUE}${audio_dirpath}${NC}${LINE_BREAK_CHARACTER}"
  }

  list_audio_data_its_album() {
    local album_dirpath="$1"
    local preffix_tree_tag="$2"
    local audio_dirpath_arr=($album_dirpath/*/)
    local audio_dirpath_arr_length=${#audio_dirpath_arr[@]}
    
    local idx=0
    while [ $idx -lt $((audio_dirpath_arr_length-1)) ]
    do
      append_audio_data2list_str "${audio_dirpath_arr[$idx]}" "$preffix_tree_tag $TREE_TAG_T"
      ((idx++))
    done
    append_audio_data2list_str "${audio_dirpath_arr[$idx]}" "$preffix_tree_tag $TREE_TAG_L"
  }

  list_all() {
    local album_dirpath_arr=($DATA_DIRPATH/*/)
    local album_dirpath_arr_length=${#album_dirpath_arr[@]}
    local idx=0
    
    while [ $idx -lt $((album_dirpath_arr_length-1)) ]
    do
      append_album_data2list_str "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_T"
      list_audio_data_its_album "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_I"
      ((idx++))
    done
    append_album_data2list_str "${album_dirpath_arr[$idx]:0:-1}" "$TREE_TAG_L"
    list_audio_data_its_album "${album_dirpath_arr[$idx]:0:-1}" " $FULL_WIDTH_SPACE"

    echo -e "$list_str"
  }

  list_a_album() {
    select_album
    local album_dirpath="$RET_SELECTED_ALBUM_PATH"
    unset RET_SELECTED_ALBUM_PATH

    append_album_data2list_str "${album_dirpath}"
    list_audio_data_its_album "${album_dirpath}"

    echo ""
    echo -e "$list_str"
  }

  case $avg1 in
    ("" | "all")
      list_all;;
    ("album")
      list_a_album;;
    ("audio")
      echo "prompt to list a audio";;
  esac
}

