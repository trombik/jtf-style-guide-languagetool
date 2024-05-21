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
TEST_DIR_GOOD=`dirname "${RULE_FILE}"`/tests/good
TEST_DIR_GOOD=`realpath "${TEST_DIR_GOOD}"`
SECTION=`basename "${RULE_FILE}" | cut -d'-' -f 3 | sed -e "s/\\.xml//"`
CATEGORY=`echo "JTF-${SECTION}" | sed -e "s/\\./_/g"`
GRAMMAR_CUSTOM_FILE="${LANGUAGETOOL_DIR}/${LANGUAGETOOL_DIR_RULES}/grammar_custom.xml"
EXIT_STATUS=1

MY_NAME=`basename "$0"`
MY_OS=`uname -s`

if [ "${MY_OS}" = "FreeBSD" ]; then
    TMPFILE=`mktemp -t "${MY_NAME}"` || exit 1
    TMPFILE_SENTENCE=`mktemp -t "${MY_NAME}-sentence"` || exit 1
else
    TMPFILE=`mktemp "${MY_NAME}.XXXXXXXXXX"` || exit 1
    TMPFILE_SENTENCE=`mktemp --tmpdir "${MY_NAME}-sentence.XXXXXXXXXX"` || exit 1
fi

get_number_of_line() {
    local FILE=$1; shift
    wc -l "${FILE}" | sed -e 's/^[[:space:]]*//' | cut -f 1 -d' '
}

count_match()
{
    local file=$1; shift
    local n_matches=`(cd ${LANGUAGETOOL_DIR} && \
        java -jar languagetool-commandline.jar \
             --language ja-JP \
             --rulefile "${RULE_FILE}" \
             --enablecategories "${CATEGORY}" \
             -eo \
             --json ${file}) | jq '[ .matches[] ]| length'`
    echo "${n_matches}"
}

show_match_result()
{
    local file=$1; shift
    local n_matches=`(cd ${LANGUAGETOOL_DIR} && \
        java -jar languagetool-commandline.jar \
             --language ja-JP \
             --rulefile "${RULE_FILE}" \
             --enablecategories "${CATEGORY}" \
             -eo \
             --json ${file}) | jq`
}

cleanup()
{
    rm -f "${GRAMMAR_CUSTOM_FILE}"
    rm -f "${TMPFILE}"
    rm -f "${TMPFILE_SENTENCE}"
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
if [ $? -ne 0 ]; then
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
if [ ${EXIT_STATUS} -ne 0 ]; then
    echo "xmllint failed exit status: ${EXIT_STATUS}"
    cleanup_and_fail
fi

echo "Starting local tests (bad)..."
for F in `ls -1 ${TEST_DIR_BAD}/*.txt`; do

    echo "Testing ${F} ..."
    N_LINES=`get_number_of_line ${F}`

    # skip if the test is empty
    if [ ${N_LINES} -eq 0 ]; then
        echo "${F} is empty, skipping"
        continue
    fi
    while read -r LINE; do
        echo "Test sentence: [${LINE}]"
        echo "${LINE}" > "${TMPFILE_SENTENCE}"
        N_MATCHES=`count_match "${TMPFILE_SENTENCE}"`
        echo "Actual match: ${N_MATCHES}"
        if [ ${N_MATCHES} -ne 1 ]; then
            echo "Test failed on test file: ${F}"
            echo "Re-running the test to show the output ..."
            show_match_result "${TMPFILE_SENTENCE}"
            cleanup_and_fail
        fi
    done < "${F}"
done

echo "Starting local tests (good)..."
for F in `ls -1 ${TEST_DIR_GOOD}/*.txt`; do

    echo "Testing ${F} ..."
    N_LINES=`get_number_of_line ${F}`

    # skip if the test is empty
    if [ ${N_LINES} -eq 0 ]; then
        echo "${F} is empty, skipping"
        continue
    fi
    while read -r LINE; do
        echo "Test sentence: [${LINE}]"
        echo "${LINE}" > "${TMPFILE_SENTENCE}"
        N_MATCHES=`count_match "${TMPFILE_SENTENCE}"`
        echo "Actual match: ${N_MATCHES}"
        if [ ${N_MATCHES} -ne 0 ]; then
            echo "Test failed on test file: ${F}"
            echo "Re-running the test to show the output ..."
            show_match_result "${TMPFILE_SENTENCE}"
            cleanup_and_fail
        fi
    done < "${F}"
done
echo "Success"
cleanup
exit 0
