# Type = Sucker
module Mongoid
  module Kraken
    class Sucker
      include Mongoid::Document
      field :name, :type => String
      references_many :tentacles, :class_name => 'Mongoid::Kraken::Tentacle'
    end
  end
end