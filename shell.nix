{
  pkgs ? import <nixpkgs> {},
}:

with pkgs;

mkShell {
  buildInputs = [
    sane-backends # scanimage
    gimp
    deskew
    tesseract

    # not used by tesseract?
    # hunspellDicts.de-de
    # hunspellDicts.en-us

    # hocr editors
    # nur.repos.milahu.scribeocr
    # hocr-tools
    # nur.repos.milahu.archive-hocr-tools
    # gImageReader
    # gImageReader-qt

    # prettier
  ];
}
