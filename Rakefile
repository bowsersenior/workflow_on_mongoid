require 'bundler'
Bundler.setup(:default, :development)

require "rake"
require "rake/rdoctask"
require 'rake/testtask'

# require "rspec"
# require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "workflow_on_mongoid/version"

desc 'Default: run all tests.'
task :default => :test

desc "Test the workflow_on_mongoid plugin."
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.test_files = Dir["test/*_test.rb"]
  t.verbose = true
end