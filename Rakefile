# frozen_string_literal: true

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
    <rules xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" lang="ja" xsi:noNamespaceSchemaLocation="../rules.xsd">
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
