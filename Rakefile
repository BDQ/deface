require 'rake'
require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rspec'
require 'rspec/core/rake_task'

desc 'Default: run specs'
task :default => :spec  
Rspec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end


task :default => :spec

desc 'Generate documentation for the deface plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Spreme'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "deface"
    gem.summary = "Deface is a library that allows you to customize ERB views in Rails"
    gem.description = "Deface is a library that allows you to customize ERB views in a Rails application without editing the underlying view."
    gem.email = "brian@railsdog.com"
    gem.homepage = "http://github.com/BDQ/Deface"
    gem.authors = ["Brian Quinn"]
    gem.files = Dir["*", "{lib}/**/*"]
    gem.add_dependency("nokogiri", "~> 1.4.3")
    gem.add_dependency("rails", "~> 3.0.0")
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
