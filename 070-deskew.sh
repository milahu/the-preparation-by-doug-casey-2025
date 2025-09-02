#!/usr/bin/env bash

cd "$(dirname "$0")"
src=060-rotate-crop-level
dst=$(basename "$0" .sh)

mkdir -p $dst

t1=$(date --utc +%s)
num_pages=0

for i in $src/*; do

  # FIXME use $num_pages and $scan_format
  page_number=${i%.tiff}
  page_number=${page_number##*/}
  page_number=${page_number#0}
  page_number=${page_number#0}
  page_number=${page_number#0}
  page_number=${page_number#0}

  o=$dst/${i##*/}

  [ -e "$o" ] && continue

  echo + deskew -o "$o" "$i"
  deskew -o "$o" "$i"

  num_pages=$((num_pages + 1))

  # [ "$page_number" = 10 ] && break # debug

done

t2=$(date --utc +%s)
echo "done $num_pages pages in $((t2 - t1)) seconds"
