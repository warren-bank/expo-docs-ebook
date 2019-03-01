#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/install.sh"
source "${DIR}/copy_assets.sh"

gitbook mobi "$DIR_EBOOK_SRC" "${DIR_EBOOK_DIST}/expo-sdk-${ebook_version}.mobi"
