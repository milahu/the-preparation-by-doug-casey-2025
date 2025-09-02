#!/usr/bin/env bash

cd "$(dirname "$0")"
dst=$(basename "$0" .sh)

if true; then
  source 030-measure-page-size.txt
else
  num_pages=372
  scan_x=210
  scan_y=148
  scan_mode="True Gray"
  scan_source="Automatic Document Feeder(left aligned,Duplex)"
  scan_resolution=300
  # scan_format=pnm # https://github.com/galfar/deskew/issues/59
  scan_format=tiff
fi

mkdir -p $dst

set -eux

page_num_fmt="%0${#num_pages}d"

args=(
  sudo
  scanimage
  #--device-name="brother5:bus3;dev1"
  --device-name="$1" # scanimage -L
  --resolution="$scan_resolution"
  --format="$scan_format"
  --mode="$scan_mode"
  --source="$scan_source"
  --MultifeedDetection=yes
  --SkipBlankPage=no
  -x "$scan_x"
  -y "$scan_y"
  --batch="$dst/$page_num_fmt.$scan_format"
  --progress
  --batch-print
  --batch-start="$2"
)

t1=$(date --utc +%s)
num_pages_1=$(ls $dst | wc -l)

"${args[@]}"

num_pages_2=$(ls $dst | wc -l)
t2=$(date --utc +%s)
echo "done $((num_pages_2 - num_pages_1)) pages in $((t2 - t1)) seconds"
