# AttributeGroup = Kraken
module Mongoid
  module Kraken
    class Kraken
      include Mongoid::Document
      field :name, :type => String
      referenced_in   :parent,   :class_name => 'Mongoid::Kraken::Kraken'
      references_many :children, :inverse_of => :parent, :class_name => 'Mongoid::Kraken::Kraken'
      references_and_referenced_in_many :tentacles, :class_name => 'Mongoid::Kraken::Tentacle'
      #references_many :krakens, :class_name => 'Kraken'

      def all_tentacles
        if parent.nil?
          return self.tentacles
        else
          out = []
          out << self.tentacles
          out << self.parent.all_tentacles
          out
        end
      end
    end
  end
end