# frozen_string_literal: true

require "pathname"

jouyou_kanji_file = Pathname.new(__FILE__).dirname / "jouyou_kanji.txt"
jis_0213_file = Pathname.new(__FILE__).dirname / "jisx0213-2004-8bit-std.txt"
non_jouyou_kanji = []

jouyou_kanji = File.open(jouyou_kanji_file.to_s).readlines.each(&:chomp!).join

# convert Unicode code point in string to the corresponding character
def u_to_s(codepoint)
  _i, u = codepoint.split("+")
  u.to_i(16).chr("UTF-8")
end

f = File.open(jis_0213_file)
f.each_line do |line|
  _sjis, unicode, name, _note = line.split("\t")
  next unless name =~ /#\s+(<cjk>|CJK)/

  chr = u_to_s(unicode)
  non_jouyou_kanji << chr unless jouyou_kanji.include? chr
end

puts non_jouyou_kanji.join
