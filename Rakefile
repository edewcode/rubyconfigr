# encoding: utf-8

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rubyconfigr"
  gem.homepage = "http://github.com/edewcode/rubyconfigr"
  gem.license = "Apache License 2.0"
  gem.summary = %Q{summary}
  gem.description = %Q{description}
  gem.email = "edewcode@gmail.com"
  gem.authors = ["kartik narayana maringanti"]
  gem.version = "1.0"
  gem.files = FileList['lib/**/*.rb', '[A-Z]*', 'test/**/*'].to_a
  gem.add_dependency 'nokogiri', '>= 1.5.0'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rubyconfigr #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
