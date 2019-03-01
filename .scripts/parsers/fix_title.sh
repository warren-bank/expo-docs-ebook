#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/../env.sh"

shopt -s globstar
set -e

# ------------------------------------------------------------------------------

fix_title_in_file() {
  local filepath="$1"

  local boundary='---'
  local regexp_title='^title:\s+(.*)$'
  local replac_title='<center><h1>$1</h1></center>\n'

  local pe=''
  pe="$pe"' my $pattern_title = qr/'$regexp_title'/;'

  # =================================
  # state:
  #   0 = no header
  #   1 = processing header
  #   2 = finished processing header
  # =================================
  pe="$pe"' if($. == 1){'
  pe="$pe"'   chomp;'
  pe="$pe"'   if ($_ eq "'$boundary'"){'
  pe="$pe"'     $state = 1;'
  pe="$pe"'     $_ = "";'
  pe="$pe"'   }'
  pe="$pe"'   else {'
  pe="$pe"'     $state = 0;'
  pe="$pe"'   }'
  pe="$pe"' }'
  pe="$pe"' elsif($state == 1){'
  pe="$pe"'   chomp;'
  pe="$pe"'   if ($_ eq "'$boundary'"){'
  pe="$pe"'     $state = 2;'
  pe="$pe"'     $_ = "";'
  pe="$pe"'   }'
  pe="$pe"'   elsif (m/$pattern_title/){'
  pe="$pe"'     my $title = "$1";'
  pe="$pe"'     my $href  = "'$filepath'" =~ s|^.*?/src/(pages/)|\1|r;'

  pe="$pe"'     $_ = "<center><h1>${title}</h1></center>\n";'

  pe="$pe"'     $title =~ s|(["])|\\\1|g;'
  pe="$pe"'     $href  =~ s|(["])|\\\1|g;'
  pe="$pe"'     print STDERR qq(  ["$href", "$title"],\n);'
  pe="$pe"'   }'
  pe="$pe"'   else {'
  pe="$pe"'     $_ = "";'
  pe="$pe"'   }'
  pe="$pe"' }'

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

fix_all_titles() {
  echo 'fixing: page titles'

  local navigation_data="${DIR_EBOOK_SRC}/.log/navigation_data.js"

  echo 'module.exports = [' >"$navigation_data"

  for i in "${DIR_EBOOK_SRC}/pages"/**/*.md; do
    # echo "$i"
    fix_title_in_file "$i" 2>>"$navigation_data"
  done

  echo ']' >>"$navigation_data"
}

# ------------------------------------------------------------------------------

fix_all_titles
