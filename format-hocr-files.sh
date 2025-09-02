#!/bin/sh

find . -name '*.hocr' |
xargs prettier --write --print-width 99999999999 --parser html
