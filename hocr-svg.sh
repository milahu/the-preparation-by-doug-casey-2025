#!/bin/sh

PYTHONPATH="$PWD/archive-hocr-tools"
# nix-build "<nixpkgs>" -A python3.pkgs.pillow
PYTHONPATH+=:/nix/store/9g2njqq6h2f9lrdpdcmyyd0i5jvzhkjg-python3.13-pillow-11.2.1/lib/python3.13/site-packages
# nix-build "<nixpkgs>" -A python3.pkgs.python-fontconfig
PYTHONPATH+=:/nix/store/1bw6hwik8h6ci839nk2jx1yv0gkv7x1w-python3.13-python-fontconfig-0.6.0/lib/python3.13/site-packages
export PYTHONPATH
# echo PYTHONPATH=$PYTHONPATH >&2

exec ./archive-hocr-tools/bin/hocr-svg "$@"
