#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/../env.sh"

set -e

# ------------------------------------------------------------------------------

patch_file() {
  local filepath="$1"
  local pe="$2"

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

escape_all_jsx_codeblocks() {
  echo 'escaping: JSX code blocks'

  local filepath
  local s
  local r
  local pe
  local sq="'"

  filepath="${DIR_EBOOK_SRC}/pages/react-native/javascript-environment.md"
  s='(`)(\<View style=\{\{color: '$sq'red'$sq'\}\} \/\>)(`)'
  r='\1\{\% raw \%\}\2\{\% endraw \%\}\3'
  pe="s/${s}/${r}/g"
  patch_file "$filepath" "$pe"
}

# ------------------------------------------------------------------------------

escape_all_jsx_codeblocks
