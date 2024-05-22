# frozen_string_literal: true

template = <<XML
    <rule>
      <regexp>%%BAD%%</regexp>
      <message>カタカナ表記は、平成3年6月28日内閣告示第2号「外来語の表記」および『外来語（カタカナ）表記ガイドライン第3版』（テクニカルコミュニケーター協会）に従います。「<suggestion>%%GOOD%%</suggestion>」を使います</message>
      <example correction="%%GOOD%%"><marker>%%BAD%%</marker>は使えません</example>
    </rule>
XML
f = File.read("katakana_yougo.txt")
f.each_line do |line|
  bad, good = line.split("\t")
  puts template.gsub("%%BAD%%", bad).gsub("%%GOOD%%", good.chomp)
end
