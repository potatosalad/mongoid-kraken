require 'mongoid/kraken/kraken'
require 'mongoid/kraken/tentacle'

module Mongoid
  module Kraken
    extend ActiveSupport::Concern

    included do
      referenced_in :kraken, :class_name => 'Mongoid::Kraken::Kraken'
      after_initialize :summon_the_kraken!
    end

    def self.instantiate(attrs = nil)
      super(attrs).__send__(:summon_the_kraken!)
    end

    def kraken_fields
      self.class_eval { self.fields }
    end

  private
    def summon_the_kraken!
      unless self.kraken.nil?
        self.kraken.all_tentacles.flatten.each do |tentacle|
          tentacle_name = tentacle.name.to_s
          if tentacle_name.ends_with?("_id")
            tentacle_reference = tentacle_name.gsub(/_id$/, '')
            self.class_eval(<<CONTENTS)
              referenced_in("#{tentacle_reference}", :class_name => "#{self.class.name}")
CONTENTS
          else
            self.class_eval "field(#{tentacle.name.to_s.inspect}, :type => #{tentacle.sucker})"
          end
        end
      end
      return self
    end
  end
end