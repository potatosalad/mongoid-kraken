module Mongoid
  module Kraken
    class Sucker
      include Mongoid::Document

      field :relation, :class => Symbol, :default => :field
      field :type,     :class => String, :default => 'String'
      field :settings, :class => Hash,   :default => Hash.new

      embedded_in :tentacle, :class_name => 'Mongoid::Kraken::Tentacle'

      after_initialize :sucker_type_casting

      def self.instantiate(attrs = nil)
        super(attrs).instance_eval { sucker_type_casting }
      end

      validates_presence_of  :relation
      validates_inclusion_of :relation, :in => [
          :field,
          :referenced_in,
          :references_many,
          :references_and_referenced_in_many
        ]
      validates_presence_of :type
      validates_each :settings do |record, attr, value|
        record.errors.add attr, 'must be a Hash' unless value.is_a?(Hash)
      end

    protected
      def sucker_type_casting
        self.fields['type'].define_singleton_method(:get) { |value| value.to_s.constantize unless value.nil? }
        self.fields['type'].define_singleton_method(:set) { |value| value.to_s unless value.nil? }

        self.fields['settings'].define_singleton_method(:get) do |value|
          value ||= {}
          value.symbolize_keys! if value.respond_to?(:symbolize_keys!)
          value
        end

        return self
      end
    end
  end
end