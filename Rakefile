# frozen_string_literal: true

require "pathname"
require "shellwords"

desc "Run tests on all rules"
task :test do
  Dir.glob("rules/jtf/*.*.*/rules-ja-*.xml").each do |f|
    sh "./test.sh #{f.shellescape}" do |ok, res|
      raise "Test failed on `#{f}` with #{res.exitstatus}" unless ok
    end
  end
end
