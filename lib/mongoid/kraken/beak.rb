# AttributeGroup = Beak
module Mongoid
  module Kraken
    class Beak
      include Mongoid::Document
      field :name, :type => String
      references_and_referenced_in_many :tentacles, :class_name => 'Mongoid::Kraken::Tentacle'
      #references_many :krakens, :class_name => 'Kraken'
    end
  end
end