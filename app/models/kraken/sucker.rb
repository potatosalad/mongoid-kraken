# Type = Sucker
class Kraken::Sucker
  include Mongoid::Document
  field :name, :type => String
  references_many :tentacles, :class_name => 'Kraken::Tentacle'
end
