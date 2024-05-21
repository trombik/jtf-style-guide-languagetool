# Scripts and data related to 常用漢字, or jouyou kanji

## `mk_non_jouyou_kanji.rb`

Create a list of non-jouyou kanji characters. Due to technical limitations,
the list is not comprehensive, but usable.

The definition of "non-jouyou kanji" here:

* the kanji is NOT included in "常用漢字", and
* the kanji is included in JIS X0213.

`jisx0213-2004-8bit-std.txt` is obtained from:
[JIS X 0213のコード対応表](https://www.x0213.org/codetable/).

To generate the list, run:

```console
bundle exec ruby mk-non-jouyou-kanji.rb > non_jouyou_kanji.txt
```
