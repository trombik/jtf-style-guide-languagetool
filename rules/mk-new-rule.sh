#!/bin/sh

SECTION="$1"
ID=`echo ${SECTION} | sed -e "s/\./_/g"`
mkdir -p jtf/${SECTION}/tests/good
touch jtf/${SECTION}/tests/good/default.txt
mkdir -p jtf/${SECTION}/tests/bad
touch jtf/${SECTION}/tests/bad/default.txt


cat << __EOF__ > "jtf/${SECTION}/rules-ja-${SECTION}.xml"
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="../print.xsl" title="Pretty print" ?>
<?xml-stylesheet type="text/css" href="../rules.css" title="Easy editing stylesheet" ?>
<rules xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" lang="ja" xsi:noNamespaceSchemaLocation="../rules.xsd">
  <category id="JTF-${ID}" name="">
  </category>
</rules>
__EOF__
