#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/env.sh"

[ -d "$DIR_EBOOK_DEP" ] || mkdir "$DIR_EBOOK_DEP"

[ -d "${DIR_EBOOK_DEP}/generate_summary" ] && rm -rf "${DIR_EBOOK_DEP}/generate_summary"
mkdir "${DIR_EBOOK_DEP}/generate_summary"

wget -q -P "${DIR_EBOOK_DEP}/generate_summary" --no-check-certificate "https://github.com/expo/expo/raw/master/docs/common/navigation.js"
wget -q -P "${DIR_EBOOK_DEP}/generate_summary" --no-check-certificate "https://github.com/expo/expo/raw/master/docs/common/navigation-data.js"
wget -q -P "${DIR_EBOOK_DEP}/generate_summary" --no-check-certificate "https://github.com/expo/expo/raw/master/docs/common/sidebar-navigation-order.js"

extract_section_data() {
  local filepath="$1"

  local pe=''
  pe="$pe"' $state       = $state       || 0;'
  pe="$pe"' $block_index = $block_index || 0;'

  pe="$pe"' my (@str_open, @str_close);'
  pe="$pe"' $str_open[0]  = "const {";'
  pe="$pe"' $str_close[0] = "} = require('"'"'./sidebar-navigation-order'"'"');";'
  pe="$pe"' $str_open[1]  = "const sections = [";'
  pe="$pe"' $str_close[1] = "];";'

  pe="$pe"' my $str_open  = $str_open[$block_index];'
  pe="$pe"' my $str_close = $str_close[$block_index];'

# pe="$pe"' print ">>> " . $state . ":" . $block_index . "\n";'

  pe="$pe"' chomp;'

  pe="$pe"' if ($state == 1){'
  pe="$pe"'   if ($_ eq $str_close){'
  pe="$pe"'     $_ .= "\n";'
  pe="$pe"'     if ($block_index == $#str_open){'
  pe="$pe"'       $state = 2;'
  pe="$pe"'       $_ .= "\n" . "module.exports = sections";'
  pe="$pe"'     }'
  pe="$pe"'     else {'
  pe="$pe"'       $state = 0;'
  pe="$pe"'     }'
  pe="$pe"'     $block_index += 1;'
  pe="$pe"'   }'
  pe="$pe"'   $_ .= "\n";'
  pe="$pe"' }'
  pe="$pe"' elsif ($state == 2){'
  pe="$pe"'   $_ = "";'
  pe="$pe"' }'
  pe="$pe"' else {'
  pe="$pe"'   if ($_ eq $str_open){'
  pe="$pe"'     $state = 1;'
  pe="$pe"'     $_ .= "\n";'
  pe="$pe"'   }'
  pe="$pe"'   else {'
  pe="$pe"'     $_ = "";'
  pe="$pe"'   }'
  pe="$pe"' }'

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

extract_navigation_data() {
  local filepath="$1"

  local pe=''
  pe="$pe"' my $str_open  = "const DIR_MAPPING = {";'
  pe="$pe"' my $str_close = "};";'

  pe="$pe"' chomp;'

  pe="$pe"' if ($state == 1){'
  pe="$pe"'   if ($_ eq $str_close){'
  pe="$pe"'     $state = 2;'
  pe="$pe"'   }'
  pe="$pe"'   $_ .= "\n";'
  pe="$pe"' }'
  pe="$pe"' elsif ($state == 2){'
  pe="$pe"'   $_ = "";'
  pe="$pe"' }'
  pe="$pe"' else {'
  pe="$pe"'   if ($_ eq $str_open){'
  pe="$pe"'     $state = 1;'
  pe="$pe"'     $_ = "module.exports = {\n";'
  pe="$pe"'   }'
  pe="$pe"'   else {'
  pe="$pe"'     $_ = "";'
  pe="$pe"'   }'
  pe="$pe"' }'

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

extract_section_data    "${DIR_EBOOK_DEP}/generate_summary/navigation.js"
extract_navigation_data "${DIR_EBOOK_DEP}/generate_summary/navigation-data.js"

node "${DIR}/generate_summary.js"                                  \
  "${DIR_EBOOK_SRC}/.log/navigation_data.js"                       \
  "${DIR_EBOOK_DEP}/generate_summary/navigation.js"                \
  "${DIR_EBOOK_DEP}/generate_summary/navigation-data.js"           \
  "${DIR_EBOOK_DEP}/generate_summary/sidebar-navigation-order.js"  \
  >"${DIR}/assets/summary.md"
