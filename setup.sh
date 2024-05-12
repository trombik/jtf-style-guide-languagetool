#!/bin/sh

. env.sh

if [ ! -f "${LANGUAGETOOL_FILE_ZIP}" ]; then
    curl -O "${LANGUAGETOOL_URL}"
fi
if [ ! -d "${LANGUAGETOOL_DIR}" ]; then
    unzip "${LANGUAGETOOL_FILE_ZIP}"
fi

if [ ! -L "${LANGUAGETOOL_DIR}/${LANGUAGETOOL_DIR_RULES}/${CUSTOM_GRAMMAR_FILE_NAME}" ]; then
    ( cd "${LANGUAGETOOL_DIR}/${LANGUAGETOOL_DIR_RULES}" && ln -s "../../../../../${CUSTOM_GRAMMAR_FILE_NAME}" "${CUSTOM_GRAMMAR_FILE_NAME}" )
fi
