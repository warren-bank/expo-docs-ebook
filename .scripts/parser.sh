#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${DIR}/parsers/fix_links.sh"
source "${DIR}/parsers/escape_jsx_codeblocks.sh"
source "${DIR}/parsers/remove_embedded_snacks.sh"
