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

    protected
      def summon_the_kraken!
        unless self.kraken.nil?
          self.kraken.all_tentacles.flatten.each do |tentacle|
            tentacle_name = tentacle.name.to_s
            if tentacle_name.ends_with?("_id")
              kraken_referenced_in(tentacle)
            elsif tentacle_name.ends_with?("_ids")
              kraken_references_and_referenced_in_many(tentacle)
            else
              kraken_field(tentacle)
            end
          end
        end
        return self
      end

    private
      def kraken_field(tentacle)
        tentacle_name = tentacle.name.to_s
        self.class_eval(%Q{
          field("#{tentacle_name}", :type => #{tentacle.sucker})
        })
      end

      def kraken_referenced_in(tentacle)
        tentacle_name = tentacle.name.to_s
        tentacle_reference = tentacle_name.gsub(/_id$/, '')
        self.class_eval(%Q{
          referenced_in("#{tentacle_reference}", :class_name => "#{self.class.name}")
        })
      end

      def kraken_references_and_referenced_in_many(tentacle)
        tentacle_name = tentacle.name.to_s
        tentacle_references = tentacle_name.gsub(/_ids$/, '')
        self.class_eval(%Q{
          references_and_referenced_in_many("#{tentacle_references.pluralize}", :class_name => "#{self.class.name}")
        })
      end
    end
  end
end