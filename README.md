# Japan Translation Federation Style Guide version 3.0 for `languagetool`

## LICENCE AND COPYRIGHT NOTICE

The grammar file is distributed under [CC BY 4.0 Deed Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/)

* (c) 2019/08/20 Japan Translation Federation
* (c) 2024/05/12 Tomoyuki Sakurai (@trombik)

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
bundle exec ruby build.rb | xmllint --format - > new.xml
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
