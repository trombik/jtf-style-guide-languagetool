# frozen_string_literal: true

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

require "pathname"
require "shellwords"
require "yaml"

desc "Run tests on all rules"
task :test do
  Dir.glob("rules/jtf/*.*.*/rules-ja-*.xml").each do |f|
    sh "./test.sh #{f.shellescape}" do |ok, res|
      raise "Test failed on `#{f}` with #{res.exitstatus}" unless ok
    end
  end
end

def dtd
  # Create entities
  # NOTE: adding EntityDecl is not possible with Nokogiri
  # https://github.com/sparklemotion/nokogiri/issues/1639

  dtd = "<!DOCTYPE rules [\n"
  YAML.load_file("rules/entities.yml").each do |entity_name, definition|
    dtd = dtd.dup << "  <!ENTITY #{entity_name} '#{definition}'>\n"
  end
  dtd << "]>\n"
end

def template
  <<~TEMPLATE
     <?xml-stylesheet type="text/xsl" href="../print.xsl" title="Pretty print" ?>
     <?xml-stylesheet type="text/css" href="../rules.css" title="Easy editing stylesheet" ?>
     <!--
     This file is distributed under CC BY 4.0 Deed Attribution 4.0 International.
     https://creativecommons.org/licenses/by/4.0/

     * (c) 2019-08-20 Japan Translation Federation
     * (c) 2024-05-12 Tomoyuki Sakurai (@trombik)
     -->
     #{dtd}
    <rules lang="en" xsi:noNamespaceSchemaLocation="../../../../../../../../../languagetool-core/src/main/resources/org/languagetool/rules/rules.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    </rules>
  TEMPLATE
end

task :build do
  require "nokogiri"
  xml = Nokogiri::XML(template, nil, "UTF-8")
  rules = xml.at_xpath("//rules")
  Dir.glob("rules/jtf/*.*.*/rules-ja-*.xml").each do |f|
    Nokogiri::XML(File.read(f)).xpath("//rules/category").each do |c|
      rules.add_child(c)
    end
  end
  puts xml
end
