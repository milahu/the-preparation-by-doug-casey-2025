#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"
src=070-deskew
dst=$(basename "$0" .sh)

mkdir -p $dst

if true; then
  source 030-measure-page-size.txt
else
  # 030-measure-page-size.txt
  scan_resolution=300
  scan_format=tiff
fi

# ocr_lang=deu+eng
ocr_lang=eng

# this must be compatible with the hocr-editor
img_format=jpg; img_quality=20%
img_format=webp; img_quality=10%

./tessdata_best.sh $(echo "$ocr_lang" | tr '+' ' ')

# the page image path is relative to the workdir
# <div class='ocr_page' id='page_1' title='image "../070-deskew/005.tiff"; ...'>
# patch paths:
# sed -i -E "s|(<div class='ocr_page' id='page_[0-9]+' title='image \")[^/]+/([0-9]+\.tiff\";)|\1../070-deskew/\2|" 080-ocr/*.hocr
cd "$dst"

t1=$(date --utc +%s)
num_pages=0

for inp in ../"$src"/*."$scan_format"; do

  # FIXME use $num_pages and $scan_format
  page_number=${inp%.tiff}
  page_number=${page_number##*/}
  page_number=${page_number#0}
  page_number=${page_number#0}

  out=${inp##*/}
  out=${out%.tiff}
  # out=$dst/$out

  out1=$out.hocr
  if ! [ -e $out1 ]; then
    # TODO? use OCRopus https://github.com/ocropus-archive/DUP-ocropy
    echo + \
    tesseract "$inp" - -c tessedit_create_hocr=1 --dpi "$scan_resolution" -l "$ocr_lang" --oem 1 --psm 6 --tessdata-dir ../tessdata_best
    tesseract "$inp" - -c tessedit_create_hocr=1 --dpi "$scan_resolution" -l "$ocr_lang" --oem 1 --psm 6 --tessdata-dir ../tessdata_best >$out1
  fi

  if false; then
    out2=$out."$img_format"; q2=20%
    if ! [ -e $out2 ]; then
      echo + magick $inp -quality "$img_quality" $out2
      magick $inp -quality "$img_quality" $out2
    fi
  fi

  num_pages=$((num_pages + 1))

  # [ "$page_number" = 10 ] && break # debug

done

t2=$(date --utc +%s)
echo "done $num_pages pages in $((t2 - t1)) seconds"
