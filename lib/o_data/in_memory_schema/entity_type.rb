module OData
  module InMemorySchema
    class EntityType < OData::AbstractSchema::EntityType
      def self.primary_key_for(cls)
        cls.primary_key
      end

      attr_reader :cls
      attr_accessor :entities

      def initialize(schema, cls, options = {})
        super(schema, cls.name.demodulize)

        key_property_name = options[:key]
        cls_properties = cls.instance_methods - Object.instance_methods
        cls_properties.each do |prop|
          p = self.Property(prop.to_s)
          @key_property = p if key_property_name.to_s == prop.to_s
          p
        end
        object_id_property = self.Property('object_id')
        @key_property ||= object_id_property
        @navigation_properties = []
        @entities = options[:entities] || []
      end

      def Property(*args)
        property = Property.new(self.schema, self, *args)
        self.properties << property
        property
      end

      def NavigationProperty(*args)
        navigation_property = NavigationProperty.new(self.schema, self, *args)
        self.navigation_properties << navigation_property
        navigation_property
      end

      def find_all(key_values = {})
        @entities
      end
      
      def find_one(key_value)
        return nil if @key_property.blank?
        find_all(@key_property => key_value).first
      end
      
      def exists?(key_value)
        !!find_one(key_value)
      end
      
      def primary_key_for(one)
        return nil if @key_property.blank?
        @key_property.value_for(one)
      end
      
      def inspect
        "#<< #{qualified_name.to_s}(#{[@properties, @navigation_properties].flatten.collect { |p| "#{p.name.to_s}: #{p.return_type.to_s}" }.join(', ')}) >>"
      end
    end
  end
end
