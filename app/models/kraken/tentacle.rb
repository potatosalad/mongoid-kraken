# Attribute = Tentacle
class Kraken::Tentacle
  include Mongoid::Document
  field :name, :type => String
  referenced_in :sucker, :class_name => 'Kraken::Sucker'
  references_many :beaks, :class_name => 'Kraken::Beak' do
    def self.extended(proxy)
      proxy.target.selector = { "kraken_tentacle_ids" => proxy.base['_id'] }
    end
  end
end