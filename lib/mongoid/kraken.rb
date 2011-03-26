require 'mongoid/kraken/kraken'
require 'mongoid/kraken/tentacle'

require 'mongoid/kraken/autoload'

module Mongoid
  module Kraken
    extend ActiveSupport::Concern

    included do
      referenced_in :kraken, :class_name => 'Mongoid::Kraken::Kraken'
      after_initialize :summon_the_kraken!
    end

    module ClassMethods
      def instantiate(attrs = nil)
        super(attrs).__send__(:summon_the_kraken!)
      end
    end

    module InstanceMethods
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
            elsif tentacle_name.ends_with?("_ids")
              tentacle_references = tentacle_name.gsub(/_ids$/, '')
              self.class_eval(<<CONTENTS)
                references_and_referenced_in_many("#{tentacle_references.pluralize}", :class_name => "#{self.class.name}")
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
end