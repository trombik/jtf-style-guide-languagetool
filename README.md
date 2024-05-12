# Japan Translation Federation Style Guide version 3.0 for `languagetool`

## LICENCE AND COPYRIGHT NOTICE

This file is distributed under [CC BY 4.0 Deed Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/)

* (c) 2019/08/20 Japan Translation Federation
* (c) 2024/05/12 Tomoyuki Sakurai (@trombik)

## References

* [The overview of the rules](https://dev.languagetool.org/development-overview) (please read this first)
* [The ITF Style Guide](https://www.jtf.jp/pdf/jtf_style_guide.pdf) (PDF)
* [Available postags](https://github.com/lucene-gosen/lucene-gosen/blob/5e8465e1b762bc877dfe836951ace723a331aae0/example/stoptags_ja.txt)
* [Examples for Japanese rules](https://github.com/languagetool-org/languagetool/blob/1c6058be324617a4e57dc83d528c397de6950ae4/languagetool-language-modules/ja/src/main/resources/org/languagetool/rules/ja/grammar.xml)

## References

### Unix OS

* Java
* `curl`
* `unzip`
* `xmllint`

## Setup

Clone this repository and change the current directory to the root directory
of the repository.

### For Unix

Run:

```sh
sh setup.sh
```

To test the rules, run:

```sh
cd LanguageTool-${VERSION}
sh ./testrules.sh ja
```

Replace `${VERSION}` with the version number of `languagetool`.

There should be no exceptions in the output.

To run the server, run:

```sh
cd LanguageTool-${VERSION}
java -cp languagetool-server.jar org.languagetool.server.HTTPServer -config server.properties -port 8081 -allow-origin -v
```

The server is available at [http://127.0.0.1:8081](http://127.0.0.1:8081).

An example to check a text, `abc`:

```text
http://127.0.0.1:8081/v2/check?language=ja-JP&text=abc
```

## Before commit

Always format the `grammar_custom.xml` with:

```sh
xmllint --format org/languagetool/rules/ja/grammar_custom.xml
```

There should be no error.
