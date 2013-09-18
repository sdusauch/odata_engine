module OData
  module Edm
    class DataServices
      cattr_accessor :schemas
      @@schemas = []

      attr_accessor :entity_types, :schemas
      
      def initialize(schemas = @@schemas)
        @entity_types = []
        @schemas = schemas
        schemas.each do |schema|
          @entity_types.concat(schema.entity_types)
        end
      end

      def find_entity_type(name)
        @schemas.each do |schema|
          ret = schema.find_entity_type(name)
          return ret unless ret.nil?
        end
        nil
      end

      def to_json
        { "d" => { "EntitySets" => @entity_types.collect(&:plural_name).sort } }.to_json
      end
    end
  end
end
