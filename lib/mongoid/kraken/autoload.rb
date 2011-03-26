require 'mongoid/field'

module Mongoid
  module Kraken
    module Autoload
      extend ActiveSupport::Concern

      included do |base|
        field(:kraken_id, {
          :type => BSON::ObjectId,
          :default => lambda {
            k = Mongoid::Kraken::Kraken.where(:name => "#{base.name}").first
            k.id unless k.nil?
          }
        })
      end

      module ClassMethods
        def inherited(subclass)
          super
          subclass_fields = fields.dup
          kraken_id_field = subclass_fields.delete('kraken_id')
          subclass_fields['kraken_id'] = Mongoid::Field.new(
            'kraken_id',
            kraken_id_field.options.merge({
              :default => lambda {
                k = Mongoid::Kraken::Kraken.where(:name => "#{subclass.name}").first
                k.id unless k.nil?
              }
            })
          )
          subclass.fields = subclass_fields
        end

        def kraken_autoload_config(*args)
          fields['kraken_id'].instance_variable_set('@default', lambda {
            k = Mongoid::Kraken::Kraken.where(*args).first
            k.id unless k.nil?
          })
        end
      end
    end
  end
end