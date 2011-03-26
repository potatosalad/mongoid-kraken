require 'mongoid/kraken/beak'
require 'mongoid/kraken/sucker'
require 'mongoid/kraken/tentacle'

module Mongoid
  module Kraken
    extend ActiveSupport::Concern

    included do
      referenced_in :beak, :class_name => 'Mongoid::Kraken::Beak'
      after_initialize :summon_the_kraken!
    end

    def self.instantiate(attrs = nil)
      super(attrs).__send__(:summon_the_kraken!)
    end

  private
    def summon_the_kraken!
      self.beak.tentacles.each do |tentacle|
        self.class_eval "field(#{tentacle.name.to_s.inspect}, :type => String)"
      end
      return self
    end
  end
end