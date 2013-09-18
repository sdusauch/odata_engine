require 'helper'

class Foo
  attr_reader :foo, :bar, :baz  
end

class Bar
  attr_reader :foo2, :bar2, :baz2  
end

class Baz
  # empty on purpose
end

class TestDataServices < Test::Unit::TestCase
  def test_initialize
    inmemory1 = OData::InMemorySchema::Base.new
    inmemory1.register(Foo)
    inmemory2 = OData::InMemorySchema::Base.new
    inmemory2.register(Bar)
    schemas = [inmemory1, inmemory2]
    ds = OData::Edm::DataServices.new(schemas)
    assert_equal(2, ds.entity_types.size)
  end

  def test_find_entity_type
    inmemory1 = OData::InMemorySchema::Base.new
    inmemory1.register(Foo)
    inmemory2 = OData::InMemorySchema::Base.new
    inmemory2.register(Bar)
    schemas = [inmemory1, inmemory2]
    ds = OData::Edm::DataServices.new(schemas)
    assert_equal(2, ds.schemas.size)
    assert_equal(inmemory1, ds.find_entity_type("Foo").schema)
    assert_equal(inmemory2, ds.find_entity_type(Bar).schema)
    assert(ds.find_entity_type(Baz).nil?)
  end
end