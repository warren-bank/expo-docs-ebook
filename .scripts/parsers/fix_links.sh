#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/../env.sh"

shopt -s globstar
set -e

# ------------------------------------------------------------------------------

print_all_links_in_file() {
  local filepath="$1"

  local regexp_url=''
  regexp_url="$regexp_url"'\]\('
  regexp_url="$regexp_url"'(?!https?|\/\/)'
  regexp_url="$regexp_url"'([^\)]+)\)'

  echo "links in file: ${filepath}"
  perl -ne 'my $pattern_url = qr/'$regexp_url'/; while(m/$pattern_url/g){print "    $1\n";}' "$filepath"
}

print_all_links() {
  for i in "${DIR_EBOOK_SRC}/pages"/**/*.md; do
    # echo "$i"
    print_all_links_in_file "$i"
  done
}

# ------------------------------------------------------------------------------

depth=''

get_depth_filepath() {
  local filepath="$1"

  local relpath=${filepath/*\/src\/pages/}
  #echo "$relpath"

  depth="${relpath//[^\/]}"
  depth="${#depth}"
  #echo "$depth"
}

# ------------------------------------------------------------------------------

fix_all_links_in_file() {
  local filepath="$1"
  get_depth_filepath "$filepath"

  local filename=$(basename "$filepath")
  local is_index='0'
  [ "$filename" = "index.md" ] && is_index='1'

  local regexp_url=''
  regexp_url="$regexp_url"'(\]\()'
  regexp_url="$regexp_url"'(?!https?|\/\/)'
  regexp_url="$regexp_url"'([^\)]+)(\))'

  local regexp_1='' regexp_2='' regexp_3='' regexp_4='' regexp_5='' regexp_6='' regexp_7='' regexp_8='' regexp_9=''
  local replac_1='' replac_2='' replac_3='' replac_4='' replac_5='' replac_6='' replac_7='' replac_8='' replac_9=''

  # not index (depth is assumed to be greater than 1)
  if [ $is_index -eq '0' ]; then
    # ../abc/     => abc.md
    # ../abc/#def => abc.md#def
    regexp_1='^\.\.\/(?!\.)([^\/]+?)[\/]?(#.*)?$'
    replac_1='\1.md\2'

    # ../../abc/def/     => ../abc/def.md
    # ../../abc/def/#ghi => ../abc/def.md#ghi
    regexp_2='^\.\.\/(\.\.\/)(?!\.)([^\/]+[\/][^\/]+?)[\/]?(#.*)?$'
    replac_2='\1\2.md\3'

    # ../../abc/     => ../abc/index.md
    # ../../abc/#def => ../abc/index.md#def
    regexp_3='^\.\.\/(\.\.\/)(?!\.)([^\/]+?)[\/]?(#.*)?$'
    replac_3='\1\2\/index.md\3'

    # ../../     => ../index.md
    # ../../#abc => ../index.md#abc
    regexp_4='^\.\.\/(\.\.)[\/]?(#.*)?$'
    replac_4='\1\/index.md\2'
  fi

  # index @ depth greater than 1
  if [ $is_index -eq '1' -a $depth -gt '1' ]; then
    # abc/     => abc.md
    # abc/#def => abc.md#def
    regexp_1='^(?![\.#])([^\/]+?)[\/]?(#.*)?$'
    replac_1='\1.md\2'

    # ../abc/def/     => ../abc/def.md
    # ../abc/def/#ghi => ../abc/def.md#ghi
    regexp_2='^(\.\.\/)(?!\.)([^\/]+[\/][^\/]+?)[\/]?(#.*)?$'
    replac_2='\1\2.md\3'

    # ../     => ../index.md
    # ../#abc => ../index.md#abc
    regexp_3='^(\.\.)[\/]?(#.*)?$'
    replac_3='\1\/index.md\2'
  fi

  # index @ depth equal to 1
  if [ $is_index -eq '1' -a $depth -eq '1' ]; then
    # abc/def/     => abc/def.md
    # abc/def/#ghi => abc/def.md#ghi
    regexp_1='^(?![\.#])([^\/]+[\/][^\/]+?)[\/]?(#.*)?$'
    replac_1='\1.md\2'

    # abc/     => abc/index.md
    # abc/#def => abc/index.md#def
    regexp_2='^(?![\.#])([^\/]+?)[\/]?(#.*)?$'
    replac_2='\1\/index.md\2'
  fi

  # all
  # /static/images/abc.def => repeat('../', depth) + 'images/abc.def'
  local regexp_8='^\/static\/(images\/)'
  local replac_8=$(perl -E 'say "..\\/" x '$depth)'\1'

  # all
  # strip leading whitespace and strip everything following any whitespace
  local regexp_9='(?:^\s+|\s.*$)'
  local replac_9=''

  local pe=''
  pe="$pe"' my $pattern_url = qr/'$regexp_url'/;'

  [ -n "$regexp_1" ] && pe="$pe"' my $pattern_1 = qr/'$regexp_1'/;'
  [ -n "$regexp_2" ] && pe="$pe"' my $pattern_2 = qr/'$regexp_2'/;'
  [ -n "$regexp_3" ] && pe="$pe"' my $pattern_3 = qr/'$regexp_3'/;'
  [ -n "$regexp_4" ] && pe="$pe"' my $pattern_4 = qr/'$regexp_4'/;'
  [ -n "$regexp_5" ] && pe="$pe"' my $pattern_5 = qr/'$regexp_5'/;'
  [ -n "$regexp_6" ] && pe="$pe"' my $pattern_6 = qr/'$regexp_6'/;'
  [ -n "$regexp_7" ] && pe="$pe"' my $pattern_7 = qr/'$regexp_7'/;'
  [ -n "$regexp_8" ] && pe="$pe"' my $pattern_8 = qr/'$regexp_8'/;'
  [ -n "$regexp_9" ] && pe="$pe"' my $pattern_9 = qr/'$regexp_9'/;'

  pe="$pe"' my @matches = ();'

  pe="$pe"' while(m/$pattern_url/g){'
  pe="$pe"'   my @match = ($&,$1,$2,$3);'
  pe="$pe"'   push @matches, \@match;'
  pe="$pe"' }'

  pe="$pe"' while(my $ref = shift(@matches)){'
  pe="$pe"'   my @match = @$ref;'
  pe="$pe"'   my $old_match=$match[0]; my $pre_url=$match[1]; my $old_url=$match[2]; my $post_url=$match[3]; my $new_url=$old_url;'

  [ -n "$regexp_1" ] && pe="$pe"'   $new_url =~ s/$pattern_1/'$replac_1'/g;'
  [ -n "$regexp_2" ] && pe="$pe"'   $new_url =~ s/$pattern_2/'$replac_2'/g;'
  [ -n "$regexp_3" ] && pe="$pe"'   $new_url =~ s/$pattern_3/'$replac_3'/g;'
  [ -n "$regexp_4" ] && pe="$pe"'   $new_url =~ s/$pattern_4/'$replac_4'/g;'
  [ -n "$regexp_5" ] && pe="$pe"'   $new_url =~ s/$pattern_5/'$replac_5'/g;'
  [ -n "$regexp_6" ] && pe="$pe"'   $new_url =~ s/$pattern_6/'$replac_6'/g;'
  [ -n "$regexp_7" ] && pe="$pe"'   $new_url =~ s/$pattern_7/'$replac_7'/g;'
  [ -n "$regexp_8" ] && pe="$pe"'   $new_url =~ s/$pattern_8/'$replac_8'/g;'
  [ -n "$regexp_9" ] && pe="$pe"'   $new_url =~ s/$pattern_9/'$replac_9'/g;'

  pe="$pe"'   if ($new_url ne $old_url){'
  pe="$pe"'     my $match_idx = index $_, $old_match;'
  pe="$pe"'     my $new_match = $pre_url . $new_url . $post_url;'
  pe="$pe"'     substr($_, $match_idx, length($old_match), $new_match);'
  pe="$pe"'   }'
  pe="$pe"' }'

  perl -i -pe "$pe" "$filepath"

  [ -e "${filepath}.bak" ] && rm -f "${filepath}.bak"
}

fix_all_links() {
  echo 'fixing: inter-page links'

  for i in "${DIR_EBOOK_SRC}/pages"/**/*.md; do
    # echo "$i"
    fix_all_links_in_file "$i"
  done
}

# ------------------------------------------------------------------------------

print_all_links >"${DIR_EBOOK_LOG}/links.1-pre-fix.txt"
fix_all_links
print_all_links >"${DIR_EBOOK_LOG}/links.2-post-fix.txt"
