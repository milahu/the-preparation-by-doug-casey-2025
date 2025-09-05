#!/usr/bin/env bash

s=''

# $ python
# >>> ord("'")
# 39
s+="s/&#39;/'/g;"

cd "$(dirname "$0")/.."

exec sed -i "$s" *-ocr/*.hocr
