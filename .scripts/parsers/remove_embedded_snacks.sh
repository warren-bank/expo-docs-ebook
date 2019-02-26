#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/../env.sh"

shopt -s globstar
set -e

# ------------------------------------------------------------------------------

remove_snacks_in_file() {
  local filepath="$1"
  local sq="'"

  local regexp_1='\bimport SnackEmbed from '$sq'~\/components\/plugins\/SnackEmbed'$sq';?'
  local replac_1=''

  local regexp_2='<SnackEmbed [^>]+?\/>'
  local replac_2=''

  local pe=''
  pe="$pe"' my $pattern_1 = qr/'$regexp_1'/; my $pattern_2 = qr/'$regexp_2'/;'

  pe="$pe"' s/$pattern_1/'$replac_1'/g;'
  pe="$pe"' s/$pattern_2/'$replac_2'/g;'

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

remove_all_embedded_snacks() {
  echo 'removing: SnackEmbed'

  for i in "${DIR_EBOOK_SRC}/pages"/**/*.md; do
    # echo "$i"
    remove_snacks_in_file "$i"
  done
}

# ------------------------------------------------------------------------------

remove_all_embedded_snacks
