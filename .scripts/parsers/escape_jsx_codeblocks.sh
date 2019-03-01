#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/../env.sh"

shopt -s globstar
set -e

# ------------------------------------------------------------------------------

escape_jsx_in_file() {
  local filepath="$1"

  local regexp_codeblock='(\{\{|\}\})'
  local replac_codeblock='\{\% raw \%\}\1\{\% endraw \%\}'

  local pe=''
  pe="$pe"' my $pattern_codeblock = qr/'$regexp_codeblock'/;'
  pe="$pe"' s/$pattern_codeblock/'$replac_codeblock'/g;'

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

escape_all_jsx_codeblocks() {
  echo 'escaping: JSX code blocks'

  for i in "${DIR_EBOOK_SRC}/pages"/**/*.md; do
    # echo "$i"
    escape_jsx_in_file "$i"
  done
}

# ------------------------------------------------------------------------------

escape_all_jsx_codeblocks
