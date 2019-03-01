#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export ebook_version='v32.0.0'
export ebook_commit='master'

export DIR_EBOOK=$(dirname "$DIR")

export DIR_EBOOK_DEP="${DIR_EBOOK}/dep"
export DIR_EBOOK_SRC="${DIR_EBOOK}/src"
export DIR_EBOOK_DIST="${DIR_EBOOK}/dist"

[ -d "$DIR_EBOOK_DIST" ] || mkdir "$DIR_EBOOK_DIST"

export PATH="${DIR}:${DIR_EBOOK_DEP}/Calibre Portable/Calibre:${DIR_EBOOK}/node_modules/.bin:${PATH}"
export gitbook="${DIR_EBOOK}/node_modules/gitbook-cli/bin/gitbook.js"
export ghdl="${DIR_EBOOK}/node_modules/@warren-bank/node-github-downloader-cli/bin/ghdl.js"

if [ -z "$GITBOOK_DIR" ]; then
  if [ -d "${HOME}/.gitbook" ]; then
    export GITBOOK_DIR="${HOME}/.gitbook"
  else
    export GITBOOK_DIR="${DIR_EBOOK}/node_modules/gitbook"
  fi
fi
