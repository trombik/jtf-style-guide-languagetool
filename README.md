# Japan Translation Federation Style Guide version 3.0 for `languagetool`

## Table of contents

<!-- vim-markdown-toc GFM -->

* [LICENCE AND COPYRIGHT NOTICE](#licence-and-copyright-notice)
* [Limitations](#limitations)
    * [1.1.1 本文](#111-本文)
    * [1.1.2 見出し](#112-見出し)
    * [1.1.3 箇条書き](#113-箇条書き)
    * [1.1.4 図表内のテキスト](#114-図表内のテキスト)
    * [1.1.5 図表のキャプション](#115-図表のキャプション)
    * [1.2.1 句点（。）と読点（、）](#121-句点と読点)
    * [1.2.2 ピリオド（.）とカンマ（,）](#122-ピリオドとカンマ)
    * [2.1.2 漢字](#212-漢字)
    * [2.1.3 漢字の送りがな](#213-漢字の送りがな)
    * [2.1.4 複合語の送りがな](#214-複合語の送りがな)
    * [2.1.5 カタカナ](#215-カタカナ)
    * [2.1.6 カタカナ語の長音](#216-カタカナ語の長音)
    * [2.1.7 カタカナ複合語](#217-カタカナ複合語)
    * [2.1.8 算用数字](#218-算用数字)
    * [2.1.9 アルファベット](#219-アルファベット)
    * [2.1.10 算用数字の位取りの表記](#2110-算用数字の位取りの表記)
    * [2.2.1 ひらがなと漢字の使い分け](#221-ひらがなと漢字の使い分け)
    * [2.2.2 算用数字と漢数字の使い分け](#222-算用数字と漢数字の使い分け)
    * [2.3.1 単一文字間のスペースの有無](#231-単一文字間のスペースの有無)
    * [2.3.1.2 全角文字どうし](#2312-全角文字どうし)
    * [2.3.1.3 半角文字どうし](#2313-半角文字どうし)
    * [2.3.2 かっこ類と隣接する文字の間のスペースの有無](#232-かっこ類と隣接する文字の間のスペースの有無)
* [References](#references)
* [Requirements](#requirements)
    * [Unix OS](#unix-os)
* [Setup](#setup)
    * [For Unix](#for-unix)
* [Testing a rule file](#testing-a-rule-file)
* [Building the grammar file](#building-the-grammar-file)
* [Install the grammar file](#install-the-grammar-file)
* [Running the server](#running-the-server)
* [Usage](#usage)
    * [Desktop](#desktop)
    * [OmegaT](#omegat)

<!-- vim-markdown-toc -->

## LICENCE AND COPYRIGHT NOTICE

The grammar file is distributed under [CC BY 4.0 Deed Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/)

* &copy; 2019/08/20 Japan Translation Federation
* &copy; 2024/05/12 Tomoyuki Sakurai (@trombik)

Other files are under [ISC license](ISC).

## Limitations

In general, the rules are imperfect due to limitations in the implementation
(XML, the unmaintained back-end tagger,
[lucene-gosen](https://github.com/lucene-gosen/lucene-gosen), and
the sentence-based approach of `languagetool`). This is especially problematic
when creating a style rule that checks spaces and special characters.

The goal is, creating *80% good* grammar file so that `OmegaT` can suggest
possible mistakes in Japanese target files.

The below is a non-exhaustive list of the known limitations.

### 1.1.1 本文

Not supported at all.

### 1.1.2 見出し

Not supported at all.

### 1.1.3 箇条書き

Not supported at all.

### 1.1.4 図表内のテキスト

Not supported at all.

### 1.1.5 図表のキャプション

Not supported at all.

### 1.2.1 句点（。）と読点（、）

As rules are sentence-based, punctuation marks cannot be enforced.

### 1.2.2 ピリオド（.）とカンマ（,）

Not perfect, needs more test cases.

### 2.1.2 漢字

Some non-常用漢字 might not be detected. See
[the definition of non-常用漢字](rules/utils/non-jouyou-kanji/).

### 2.1.3 [漢字の送りがな](rules/jtf/2.1.3)

All the bad examples in the style guide are supported. There should be more
checks.

### 2.1.4 [複合語の送りがな](rules/jtf/2.1.4)

All the bad examples in the style guide are supported. There should be more
checks.

### 2.1.5 カタカナ

Supported, but the coverage is not comprehensive.

### 2.1.6 カタカナ語の長音

All the bad examples in the style guide are checked. There should be more bad
rules.

### 2.1.7 [カタカナ複合語](rules/jtf/2.1.7)

The rule does not check "カタカナ複合語". However, it warns if more than 11
katakana characters are found.

### 2.1.8 [算用数字](rules/jtf/2.1.8)

Only checks simple patterns. Does not fully match complicated ones, such as "
９，０００" or "±９．００", only partially.

### 2.1.9 [アルファベット](rules/jtf/2.1.9)

Supported.

### 2.1.10 [算用数字の位取りの表記](rules/jtf/2.1.10)

The "ZENKAKU" decimal point, or "．", cannot be checked.

### 2.2.1 ひらがなと漢字の使い分け

Supported.

### 2.2.2 算用数字と漢数字の使い分け

It does not detect possible mistakes, such as "一億2000万円".

### 2.3.1 単一文字間のスペースの有無

Unsupported.

### 2.3.1.2 全角文字どうし

Unsupported.

### 2.3.1.3 半角文字どうし

Unsupported.

### 2.3.2 かっこ類と隣接する文字の間のスペースの有無

Unsupported.

## References

* [The overview of the rules](https://dev.languagetool.org/development-overview) (please read this first)
* [The ITF Style Guide](https://www.jtf.jp/pdf/jtf_style_guide.pdf) (PDF)
* [Available postags](https://github.com/lucene-gosen/lucene-gosen/blob/5e8465e1b762bc877dfe836951ace723a331aae0/example/stoptags_ja.txt)
* [Examples for Japanese rules](https://github.com/languagetool-org/languagetool/blob/1c6058be324617a4e57dc83d528c397de6950ae4/languagetool-language-modules/ja/src/main/resources/org/languagetool/rules/ja/grammar.xml)

## Requirements

### Unix OS

* Java
* `curl`
* `unzip`
* `xmllint`
* `jq`
* `ruby` and `bundler` (for build, optional)

## Setup

Clone this repository and change the current directory to the root directory
of the repository.

### For Unix

Run:

```sh
sh setup.sh
```

## Testing a rule file

To test the rules, run:

```sh
sh test.sh $RULE_XML
```

For instance:

```sh
sh test.sh rules/jtf/2.1.8/rules-ja-2.1.8.xml
```

There should be no exceptions in the output.

## Building the grammar file

Make sure to install `ruby` and `bundler`. `bundle install` will install all
the dependencies.

Run:

```sh
bundle exec rake build | xmllint --format - > grammar_custom.xml
```

## Install the grammar file

```sh
cp new.xml LanguageTool-6.4/org/languagetool/rules/ja/grammar_custom.xml
```


## Running the server

To run the server, run:

```sh
cd LanguageTool-${VERSION}
java -cp languagetool-server.jar org.languagetool.server.HTTPServer -config server.properties -port 8081 -allow-origin -v
```

The server is available at [http://127.0.0.1:8081](http://127.0.0.1:8081).  To
see if it works, call `languages` API, i.e.
[http://127.0.0.1:8081/v2/languages](http://127.0.0.1:8081/v2/languages).

Available API verbs are listed at:
[https://languagetool.org/http-api/swagger-ui/](https://languagetool.org/http-api/swagger-ui/)

An example to check a text, `abc`:

```text
http://127.0.0.1:8081/v2/check?language=ja-JP&text=abc
```

## Usage

### Desktop

TBW.

### OmegaT

For OmegaT, open `Options` > `Preferences` > `LanguageTool`. Select `Remote
server`, and type `http://127.0.0.1:8081/v2/check` in `URL`.

Click `View` in the menu bar, check `Mark Language Checker Issues`.

After that, matched words, or violations, are underscored with a wavy line.
