#!/usr/bin/env bash

# NOTE this must run before deskew
# beause my scanner leaves extra space at the bottom of pages
# with a horizontal edge which is not parallel to the page edge
# so that "false edge" would distort the deskew result

cd "$(dirname "$0")"
src=040-scan-pages
dst=$(basename "$0" .sh)

if true; then
  source 030-measure-page-size.txt
  source 050-measure-crop-size.txt
else
  # 030-measure-page-size.txt
  num_pages=372
  scan_format=tiff

  # 050-measure-crop-size.txt
  # original size: 1748x2480
  crop_size=1580x2480
  crop_x=168
  lowthresh=20; highthresh=90
  level=${lowthresh}x${highthresh}%
  rotate_odd=090
  rotate_even=270
  crop_odd_expr='echo ${crop_size}+$crop_x+0'
  crop_even_expr='echo ${crop_size}+000+0'
fi

mkdir -p $dst

t1=$(date --utc +%s)
num_pages=0

for i in $src/*; do

  # FIXME use $num_pages and $scan_format
  page_number=${i%.tiff}
  page_number=${page_number##*/}
  page_number=${page_number#0}
  page_number=${page_number#0}

  o=$dst/${i##*/}

  [ -e "$o" ] && continue

  if ((page_number % 2 == 1)); then
    rot=$rotate_odd
    crop="$(eval "$crop_odd_expr")"
  else
    rot=$rotate_even
    crop="$(eval "$crop_even_expr")"
  fi

  echo + magick "$i" -rotate $rot -crop $crop -level $level "$o"
  magick "$i" -rotate $rot -crop $crop -level $level "$o"

  num_pages=$((num_pages + 1))

  # [ "$page_number" = 10 ] && break # debug

done

t2=$(date --utc +%s)
echo "done $num_pages pages in $((t2 - t1)) seconds"
