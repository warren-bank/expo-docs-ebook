#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/env.sh"

shopt -s globstar
shopt -s dotglob

if [ ! -d "$DIR_EBOOK_SRC" ]; then
  mkdir "$DIR_EBOOK_SRC"

  ghdl -P "$DIR_EBOOK_SRC" -u "https://github.com/expo/expo/tree/${ebook_commit}/docs/static/images"
  ghdl -P "$DIR_EBOOK_SRC" -u "https://github.com/expo/expo/tree/${ebook_commit}/docs/pages/versions/${ebook_version}"

  # normalize path to markdown files
  mv "${DIR_EBOOK_SRC}/${ebook_version}" "${DIR_EBOOK_SRC}/pages"

  # create a directory for parser logs
  mkdir "${DIR_EBOOK_SRC}/.log"

  # fix links in markdown files
  source "${DIR}/parser.sh"

  # generate: 'assets/summary.md'
  source "${DIR}/generate_summary.sh"

  cp --no-clobber "${DIR}/assets"/* "$DIR_EBOOK_SRC"
fi
