require 'mongoid/field'

module Mongoid
  module Kraken
    module Autoload
      extend ActiveSupport::Concern

      included do |base|
        field(:kraken_id, {
          :type => BSON::ObjectId,
          :default => kraken_autoload_default(:name => "#{base.name}")
        })
      end

      module ClassMethods
        attr_accessor :kraken_autoload_key

        def inherited(subclass)
          super
          subclass_fields = fields.dup
          kraken_id_field = subclass_fields.delete(kraken_autoload_key)
          subclass_fields[kraken_autoload_key] = Mongoid::Field.new(
              kraken_autoload_key,
              :default => kraken_autoload_default(:name => "#{subclass.name}")
            )
          subclass.fields = subclass_fields
        end

        def kraken_autoload_config(*args)
          fields[kraken_autoload_key].instance_variable_set('@default', kraken_autoload_default(*args))
        end

        def kraken_autoload_key
          @kraken_autoload_key ||= 'kraken_id'
        end

      protected
        def kraken_autoload_default(*args)
          lambda {
            k = Mongoid::Kraken::Kraken.where(*args).first
            k.id unless k.nil?
          }
        end
      end
    end
  end
end