module OData
  module InMemorySchema
    class NavigationProperty < OData::AbstractSchema::NavigationProperty
      def self.name_for(reflection)
        reflection.name.to_s
      end

      def self.association_for(schema, reflection)
        schema.Association(reflection)
      end

      def initialize(schema, entity_type, reflection)
        super(schema, entity_type, self.class.name_for(reflection), self.class.association_for(schema, reflection), :source => true)
      end

      def method_name
        self.association.reflection.name.to_sym
      end

      def find_all(one, key_values = {})
        nil    
      end

      def find_one(one, key_value = nil)
        nil
      end
    end
  end
end
