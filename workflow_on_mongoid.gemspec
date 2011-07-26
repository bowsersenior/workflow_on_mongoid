# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'workflow_on_mongoid/version'

Gem::Specification.new do |s|
  s.name        = "workflow_on_mongoid"
  s.version     = WorkflowOnMongoid::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mani Tadayon"]
  s.email       = ["bowsersenior@gmail.com"]
  s.homepage    = "http://github.com/bowsersenior/workflow_on_mongoid"
  s.summary     = "Add Mongoid support to the Workflow gem."
  s.description = "Lets you use the Workflow gem with your Mongoid documents to add state machine functionality."

  s.add_dependency "workflow", '~>0.8'
  s.add_dependency "mongoid", '>=2.0.0.rc.1'
  s.add_dependency "bson_ext"

  s.add_development_dependency "rake", '0.9.2'
  s.add_development_dependency "rspec", '>=2.6.0'
  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "mocha"
  s.add_development_dependency "ruby-debug"

  s.required_rubygems_version = ">= 1.3.7"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- spec/*`.split("\n")
  s.extra_rdoc_files = ["MIT_LICENSE", "README.rdoc"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path = "lib"
end

