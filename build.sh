#!/bin/sh

. env.sh

( cd "${LANGUAGETOOL_DIR}" && sh ./testrules.sh ja )
