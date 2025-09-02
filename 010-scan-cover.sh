#!/usr/bin/env bash

# $ scanimage -L
# device `genesys:libusb:003:013' is a Canon LiDE 100 flatbed scanner

# $ scanimage --help -d "genesys:libusb:003:013"

cd "$(dirname "$0")"
dst=$(basename "$0" .sh)

mkdir -p $dst

set -eux

o="$dst/$(date +%s).tiff"

args=(
  # sudo
  scanimage
  #--device-name="genesys:libusb:003:013"
  --device-name="$1" # scanimage -L
  #--resolution=300
  --resolution=600
  # --format=pnm # https://github.com/galfar/deskew/issues/59
  --format=tiff
  --mode="Color"
  --progress
  --output-file="$o"
)

"${args[@]}"

echo "TODO manually rotate and crop $o"
echo "hint:"
echo "  gimp $o"
