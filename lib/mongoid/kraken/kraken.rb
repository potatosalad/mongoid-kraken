# AttributeGroup = Kraken
module Mongoid
  module Kraken
    class Kraken
      include Mongoid::Document
      field :name, :type => String
      referenced_in   :parent,   :inverse_of => :children, :class_name => 'Mongoid::Kraken::Kraken'
      references_many :children, :inverse_of => :parent,   :class_name => 'Mongoid::Kraken::Kraken'
      references_and_referenced_in_many :tentacles, :class_name => 'Mongoid::Kraken::Tentacle'

      def all_tentacles
        if parent.nil?
          return self.tentacles
        else
          out = []
          out << self.parent.all_tentacles
          out << self.tentacles
          out
        end
      end

      validates_presence_of :name
      validates_uniqueness_of :name
    end
  end
end