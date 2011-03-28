# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "mongoid/kraken/version"

Gem::Specification.new do |s|
  s.name        = 'mongoid-kraken'
  s.version     = Mongoid::Kraken::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Andrew Bennett']
  s.email       = ['potatosaladx@gmail.com']
  s.homepage    = 'http://github.com/potatosalad/mongoid-kraken'
  s.summary     = 'Kraken is EAV done right'
  s.description = 'Kraken is an implementation of the EAV (Entity-Attribute-Value) model using mongoid'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_runtime_dependency('mongoid', ['>= 2.0.0.rc.8'])

  s.add_development_dependency('rspec', ['~> 2.5'])
  s.add_development_dependency('autotest', ['>= 4.4'])
  s.add_development_dependency('yard', ['>= 0.6.5'])

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE.txt README.rdoc Rakefile)
  s.require_path = 'lib'
end