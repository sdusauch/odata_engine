require 'helper'

class TestQuery < Test::Unit::TestCase
  def setup
    data_services = OData::Edm::DataServices.new
    @parser = OData::Core::Parser.new(data_services)
    @schema = OData::InMemorySchema::Base.new
    @schema.register(Test::Foo, :foo)
    assert_equal(1, @schema.entity_types.length, "unexpected number of entity types")
    data_services.schemas << @schema
    assert_equal(1, data_services.schemas.length, "unexpected number of schemas")
    foo_entities = @schema.find_entity_type(Test::Foo).entities
    assert_equal(0, @schema.find_entity_type(Test::Foo).entities.length)
    foo_entities << Test::Foo.new("a", "b", "c")
    foo_entities << Test::Foo.new("1", "2", "3")
    assert_equal(2, @schema.find_entity_type(Test::Foo).entities.length)
  end
  
  def test_query_all
    assert_equal(2, @schema.find_entity_type(Test::Foo).entities.length)
    query = @parser.parse! "Foo"
    res = query.execute!
    assert_equal(2, res.length)
  end

  def test_query_find
    assert_equal(2, @schema.find_entity_type(Test::Foo).entities.length)
    query = @parser.parse! "Foo?$filter=bar eq 'b'"
    res = query.execute!
    assert_equal(1, res.length)
  end
end