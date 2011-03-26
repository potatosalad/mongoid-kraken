# Attribute = Tentacle
module Mongoid
  module Kraken
    class Tentacle
      include Mongoid::Document
      field :name, :type => String
      referenced_in :sucker, :class_name => 'Mongoid::Kraken::Sucker'
      references_many :beaks, :class_name => 'Mongoid::Kraken::Beak' do
        def self.extended(proxy)
          proxy.target.selector = { "mongoid_kraken_tentacle_ids" => proxy.base['_id'] }
        end
      end
    end
  end
end