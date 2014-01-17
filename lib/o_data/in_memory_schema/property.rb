module OData
  module InMemorySchema
    class Property < OData::AbstractSchema::Property
      cattr_reader :edm_null
      @@edm_null = 'Edm.Null'.freeze
      
      attr_reader :entity_type
      attr_accessor :return_type, :nullable

      def initialize(schema, entity_type, name, return_type = @@edm_null, nullable = true)
        super(schema, entity_type, name)

        @entity_type = entity_type
        @return_type = 'Edm.String'
        @nullable = nullable
      end
      
      def value_for(one)
        if (entity_type.respond_to?(:stringify)) then
          entity_type.stringify(@name, one.send(@name))
        else
          one.send(@name)
        end
      end
    end
  end
end
