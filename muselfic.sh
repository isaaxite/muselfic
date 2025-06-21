#!/bin/sh
. script/dist.sh
. script/metadata.sh
. script/extract.sh

topest_avg1=$1
shift
case $topest_avg1 in
  ("dist") dist_data "$@";;
  ("list") echo "list";;
  ("metadata") add_metadata_asset "$@";;
  ("extract") extract_audio_to "$@";;
  (*)
    echo "Wrong <rule>! You should type \"dist\" or \"list\" or \"metadata\" or \"extract\""
    exit 1
esac
