$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "mongoid"
require "mongoid-kraken"

require "rspec"

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('mongoid_kraken_test')
end

Dir[ File.join(File.dirname(__FILE__), "support", "**/*.rb") ].each { |file| require file }

RSpec.configure do |config|
  config.mock_with(:rspec)
  config.after(:each) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end