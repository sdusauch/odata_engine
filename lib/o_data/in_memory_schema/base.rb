module OData
  module InMemorySchema
    class Base < OData::AbstractSchema::Base
      attr_reader :classes
      
      def initialize(namespace = "OData", options = {})
        super(namespace)
        @classes = options[:classes] || []
        super(namespace)
        self.register(classes)
      end

      def register(cls, key = nil)
        if (cls.respond_to?(:each))
          cls.each do |c|
            register(c, key)
          end
        else
          if (find_entity_type(cls))
            raise OData::Core::Errors::EntityTypeAlreadyRegistered.new(cls.name)
          end
          self.EntityType(cls, :reflect_on_associations => false, :key => key)
        end
      end
      
      def EntityType(*args)
        entity_type = EntityType.new(self, *args)
        @entity_types << entity_type
        entity_type
      end

      def find_entity_type(name)
        if name.respond_to?(:name)
          self.entity_types.find { |et| et.name == name.name.demodulize }
        else
          super
        end
      end
    end
  end
end
