require "bundler"
Bundler.setup

require "rake"
require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "mongoid/kraken/version"

task :gem => :build
desc "Build the mongoid-kraken.gem file"
task :build do
  system "gem build mongoid-kraken.gemspec"
end

desc "Install the mongoid-kraken.gem file"
task :install => :build do
  system "sudo gem install mongoid-kraken-#{Mongoid::Kraken::VERSION}.gem"
end

desc "Tag a release and push the mongoid-kraken.gem file"
task :release => :build do
  system "git tag -a #{Mongoid::Kraken::VERSION} -m 'Tagging #{Mongoid::Kraken::VERSION}'"
  system "git push --tags"
  system "gem push mongoid-#{Mongoid::VERSION}.gem"
end

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

Rspec::Core::RakeTask.new("spec:unit") do |spec|
  spec.pattern = "spec/unit/**/*_spec.rb"
end

Rspec::Core::RakeTask.new("spec:functional") do |spec|
  spec.pattern = "spec/functional/**/*_spec.rb"
end

Rspec::Core::RakeTask.new('spec:progress') do |spec|
  spec.rspec_opts = %w(--format progress)
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new