module OData
  module Core
    module Segments
      class CollectionSegment < EntityTypeAndKeyValuesSegment
        def self.parse!(query, str)
          return nil unless query.segments.empty?
          schema_object_name, key_values, keys = extract_schema_object_name_and_key_values_and_keys(str)
          return nil if schema_object_name.blank?

          entity_type = query.data_services.find_entity_type(schema_object_name.singularize)
          return nil if entity_type.blank?

          sanitized_key_values = sanitize_key_values_and_keys_for!(query, entity_type, key_values, keys)

          query.Segment(self, entity_type, sanitized_key_values)
        end
        
        def self.can_follow?(anOtherSegment)
          anOtherSegment.blank?
        end

        def valid?(results)
          !results.blank?
        end
      end # CollectionSegment
    end # Segments
  end # Core
end # OData