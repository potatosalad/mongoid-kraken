require 'mongoid/kraken/kraken'
require 'mongoid/kraken/sucker'
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
        super(attrs).instance_eval { summon_the_kraken! }
      end

      def kraken_class
        Mongoid::Kraken::Kraken
      end

      def kraken_tentacle_class
        Mongoid::Kraken::Tentacle
      end

      def kraken_sucker_class
        Mongoid::Kraken::Sucker
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
            case tentacle.sucker.relation
            when :field then
              self.class_eval(&kraken_field(self, tentacle))
            when :referenced_in then
              self.class_eval(&kraken_referenced_in(self, tentacle))
            when :references_many then
              self.class_eval(&kraken_references_many(self, tentacle))
            when :references_and_referenced_in_many then
              self.class_eval(&kraken_references_and_referenced_in_many(self, tentacle))
            end
          end
        end
        return self
      end

    private
      def kraken_field(klass, tentacle)
        tentacle_name = tentacle.name.to_s
        lambda do |base|
          field(
            tentacle_name,
            tentacle.sucker.settings.reverse_merge(:type => tentacle.sucker.type)
          )
        end
      end

      def kraken_referenced_in(klass, tentacle)
        tentacle_name = tentacle.name.to_s
        lambda do |base|
          referenced_in(
            tentacle_name,
            tentacle.sucker.settings.reverse_merge(:class_name => klass.class.name)
          )
        end
      end

      def kraken_references_many(klass, tentacle)
        tentacle_name = tentacle.name.to_s
        lambda do |base|
          references_many(
            tentacle_name,
            tentacle.sucker.settings.reverse_merge(:class_name => klass.class.name)
          )
        end
      end

      def kraken_references_and_referenced_in_many(klass, tentacle)
        tentacle_name = tentacle.name.to_s
        lambda do |base|
          references_and_referenced_in_many(
            tentacle_name,
            tentacle.sucker.settings.reverse_merge(:class_name => klass.class.name)
          )
        end
      end
    end
  end
end