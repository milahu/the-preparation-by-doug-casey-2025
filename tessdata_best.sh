#!/bin/sh

# download tessdata files from https://github.com/tesseract-ocr/tessdata_best

if [ $# = 0 ]; then
  echo "error: no arguments"
  echo "example use: ./tessdata_best.sh eng deu rus"
  exit 1
fi

urls=()
for lang in "$@"; do
  [ -e tessdata_best/"$lang".traineddata ] && continue
  urls+=(https://github.com/tesseract-ocr/tessdata_best/raw/main/"$lang".traineddata)
done

[ ${#urls[@]} = 0 ] && exit

cd "$(dirname "$0")"
mkdir -p tessdata_best
cd tessdata_best

wget --no-clobber "${urls[@]}"
