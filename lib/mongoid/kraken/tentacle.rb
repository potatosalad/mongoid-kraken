# Attribute = Tentacle
module Mongoid
  module Kraken
    class Tentacle
      include Mongoid::Document
      field :name,   :type => String
      field :label,  :type => String
      field :sucker, :type => String, :default => "String"
      references_many :krakens, :class_name => 'Mongoid::Kraken::Kraken' do
        def self.extended(proxy)
          proxy.target.selector = { "tentacle_ids" => proxy.base['_id'] }
        end
      end

      def self.instantiate(attrs = nil)
        super(attrs).__send__(:sucker_type_casting)
      end

      validates_presence_of :name
      validates_presence_of :sucker
      validates_uniqueness_of :name

    protected
      def sucker_type_casting
        self.fields['sucker'].define_singleton_method(:get) { |value| value.to_s.constantize unless value.nil? }
        self.fields['sucker'].define_singleton_method(:set) { |value| value.to_s unless value.nil? }
        return self
      end
    end
  end
end