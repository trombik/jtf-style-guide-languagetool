#!/bin/sh

# Copyright (c) 2024 Tomoyuki Sakurai <y@trombik.org>
#
# ISC license
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

. ./env.sh

RULE_FILE=`realpath "$1"`
TEST_DIR_BAD=`dirname "${RULE_FILE}"`/tests/bad
TEST_DIR_BAD=`realpath "${TEST_DIR_BAD}"`
SECTION=`basename "${RULE_FILE}" | cut -d'-' -f 3 | sed -e "s/\\.xml//"`
CATEGORY=`echo "JTF-${SECTION}" | sed -e "s/\\./_/g"`
GRAMMAR_CUSTOM_FILE="${LANGUAGETOOL_DIR}/${LANGUAGETOOL_DIR_RULES}/grammar_custom.xml"
EXIT_STATUS=1

MY_NAME=`basename "$0"`
MY_OS=`uname -s`

if [ "${MY_OS}" = "FreeBSD" ]; then
    TMPFILE=`mktemp -t "${MY_NAME}"` || exit 1
else
    TMPFILE=`mktemp "${MY_NAME}.XXXXXXXXXX"` || exit 1
fi

get_number_of_line() {
    local FILE=$1; shift
    wc -l "${FILE}" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d' '
}

cleanup()
{
    rm -f "${GRAMMAR_CUSTOM_FILE}"
    rm -f "${TMPFILE}"
}
cleanup_and_fail()
{
    cleanup
    exit 1
}

trap cleanup 2

echo "Starting languagetool tests on ${RULE_FILE}..."

rm -f "${GRAMMAR_CUSTOM_FILE}"
ln -s "${RULE_FILE}" "${GRAMMAR_CUSTOM_FILE}"

(cd LanguageTool-6.4 && sh testrules.sh ja 2>&1 ) | tee "${TMPFILE}"
if [ $? != 0 ]; then
    echo "invoking testrules.sh failed"
    cleanup_and_fail
fi

if grep -q "Exception in thread" "${TMPFILE}"; then
    echo "languagetool raised an exception"
    cleanup_and_fail
fi

if grep -q "Test failure" "${TMPFILE}"; then
    echo "languagetool tests failed"
    cleanup_and_fail
fi

echo "Starting format test..."

xmllint --format "${RULE_FILE}" > "${TMPFILE}"
EXIT_STATUS=$?
if [ ${EXIT_STATUS} != 0 ]; then
    echo "xmllint failed exit status: ${EXIT_STATUS}"
    cleanup_and_fail
fi

echo "Starting local tests..."
for F in `ls -1 ${TEST_DIR_BAD}/*.txt`; do
    N_LINES=`get_number_of_line ${F}`

    # skip if the test is empty
    if [ ${N_LINES} = 0 ]; then
        continue
    fi
    N_MATCHES=`(cd ${LANGUAGETOOL_DIR} && \
        java -jar languagetool-commandline.jar \
             --language ja-JP \
             --rulefile "${RULE_FILE}" \
             --enablecategories "${CATEGORY}" \
             -eo \
             --json ${F}) | jq '[ .matches[] ]| length'`
    if [ ${N_LINES} != ${N_MATCHES} ]; then
        echo "Expected match: ${N_LINES}"
        echo "Actual match: ${N_MATCHES}"
        echo "Test failed on test file: ${F}"
        cleanup_and_fail
    fi
done
echo "Success"
cleanup
exit 0
