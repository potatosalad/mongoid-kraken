class Star
  include Mongoid::Document
  include Mongoid::Kraken
  include Mongoid::Kraken::Autoload
  field :name, :type => String
end