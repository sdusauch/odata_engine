module OData
  class ODataException < StandardError
    def to_s
      "An unknown #{self.class.name.demodulize.to_s} has occured."
    end
  end
end

require "o_data/abstract_schema"
require "o_data/core"

require "o_data/active_record_schema"
require "o_data/in_memory_schema"
require "o_data/edm"

require "o_data/engine"
