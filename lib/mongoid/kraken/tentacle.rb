# Attribute = Tentacle
module Mongoid
  module Kraken
    class Tentacle
      include Mongoid::Document

      field :name,  :type => String
      field :label, :type => String

      embeds_one :sucker, :class_name => 'Mongoid::Kraken::Sucker'

      #references_many :krakens, :class_name => 'Mongoid::Kraken::Kraken' do
      #  def self.extended(proxy)
      #    proxy.target.selector = { "tentacle_ids" => proxy.base['_id'] }
      #  end
      #end

      before_create    :sucker_default
      after_initialize :sucker_default

      %w(relation type settings).each do |key|
        define_method("sucker_#{key}") do |*args|
          sucker_default.send(key, *args)
        end

        define_method("sucker_#{key}=") do |*args|
          sucker_default.send("#{key}=", *args)
        end
      end

      validates_presence_of :name
      validates_associated :sucker
      # Each Tentacle has a unique name and Sucker
      validates_each :name do |document, attribute, value|
        criteria = document.class.where({
            'sucker.relation' => document.sucker.relation,
            'sucker.type'     => document.sucker.type.to_s,
            'sucker.settings' => document.sucker.settings
          })
        criteria = criteria.where(attribute => Regexp.new("^#{Regexp.escape(value.to_s)}$", Regexp::IGNORECASE))
        if criteria.exists?
          document.errors.add(
            attribute,
            :taken,
            :value => value, :message => "and sucker are already taken"
          )
        end
      end

    private
      def sucker_default
        self.sucker ||= Mongoid::Kraken::Sucker.new
        return self.sucker
      end
    end
  end
end