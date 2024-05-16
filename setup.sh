#!/bin/sh

. env.sh

if [ ! -f "${LANGUAGETOOL_FILE_ZIP}" ]; then
    curl -O "${LANGUAGETOOL_URL}"
fi
if [ ! -d "${LANGUAGETOOL_DIR}" ]; then
    unzip "${LANGUAGETOOL_FILE_ZIP}"
fi
