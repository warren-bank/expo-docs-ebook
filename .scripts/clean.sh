#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/env.sh"

[ -d "$DIR_EBOOK_SRC"  ] && rm -rf "$DIR_EBOOK_SRC"
[ -d "$DIR_EBOOK_DIST" ] && rm -rf "$DIR_EBOOK_DIST"

[ -d "${DIR_EBOOK_DEP}/generate_summary" ] && rm -rf "${DIR_EBOOK_DEP}/generate_summary"

exit 0
