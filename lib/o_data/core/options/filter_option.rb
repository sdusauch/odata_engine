module OData
  module Core
    module Options
      class FilterOption < EnumeratedOption
        def self.option_name
          '$filter'
        end
        
        def self.applies_to?(query)
          true
        end
      end
    end
  end
end
