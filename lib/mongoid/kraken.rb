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
              self.class_eval(&kraken_referenced_in(self, tentacle))
            elsif tentacle_name.ends_with?("_ids")
              self.class_eval(&kraken_references_and_referenced_in_many(self, tentacle))
            else
              self.class_eval(&kraken_field(self, tentacle))
            end
          end
        end
        return self
      end

    private
      def kraken_field(klass, tentacle)
        lambda do |base|
          field(tentacle.name.to_s, tentacle.settings.reverse_merge(:type => tentacle.sucker))
        end
      end

      def kraken_referenced_in(klass, tentacle)
        tentacle_name = tentacle.name.to_s
        tentacle_reference = tentacle_name.gsub(/_id$/, '')
        lambda do |base|
          referenced_in(tentacle_reference, tentacle.settings.reverse_merge(:class_name => klass.class.name))
        end
      end

      def kraken_references_and_referenced_in_many(klass, tentacle)
        tentacle_name = tentacle.name.to_s
        tentacle_references = tentacle_name.gsub(/_ids$/, '')
        lambda do |base|
          references_and_referenced_in_many(
            "#{tentacle_references.pluralize}",
            tentacle.settings.reverse_merge(:class_name => klass.class.name)
          )
        end
      end
    end
  end
end