# AttributeGroup = Beak
class Kraken::Beak
  include Mongoid::Document
  field :name, :type => String
  references_and_referenced_in_many :tentacles, :class_name => 'Kraken::Tentacle'
  references_many :krakens, :class_name => 'Kraken'
end