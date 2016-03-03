require 'open-uri'

module WpApiClient
  module Entities
    class Base
      attr_reader :resource

      def self.build(resource)
        raise Exception if resource.nil?
        type = WpApiClient::Entities::Types.find { |type| type.represents?(resource) }
        type.new(resource)
      end

      def initialize(resource)
        unless resource.is_a? Hash
          raise ArgumentError.new('Tried to initialize a WP-API resource with something other than a Hash')
        end
        @resource = resource
      end

      def links
        resource["_links"]
      end

      def relations(relation, relation_to_return = nil)
        relationship = Relationship.new(@resource, relation)
        relations = relationship.get_relations
        if relation_to_return
          relations[relation_to_return]
        else
          relations
        end
      end
    end
  end
end
