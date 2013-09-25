require 'helper'

class TestInMemorySchema < Test::Unit::TestCase
  def test_register
    schema = OData::InMemorySchema::Base.new
    schema.register(Foo)
    assert_equal(1, schema.entity_types.size)
  end

  def test_entity_type_name_omits_module
    schema = OData::InMemorySchema::Base.new
    schema.register(Test::Foo)
    assert_equal("Foo", schema.entity_types[0].name)
  end
  
  def test_find_entity_type_ignores_module
    schema = OData::InMemorySchema::Base.new
    schema.register(Test::Foo)
    assert_equal("Foo", schema.find_entity_type("Foo").name)
    assert_equal("Foo", schema.find_entity_type(Test::Foo).name)
  end
  
  def test_find_entities
    schema = OData::InMemorySchema::Base.new(Test::Foo)
    schema.register(Test::Foo)
    (1..20).each do |n|
      schema.find_entity_type("Foo").entities.append(Test::Foo.new(n, "test", "test #{n}"))
    end
    assert_equal(20, schema.find_entity_type("Foo").entities.size)
  end
  
  def test_can_set_key_property
    schema = OData::InMemorySchema::Base.new(Test::Foo)
    schema.register(Test::Foo, :baz)
    et = schema.find_entity_type(Test::Foo)
    assert_equal("baz", et.key_property.name)
    schema.entity_types.clear
    schema.register(Test::Foo, :bar)
    et = schema.find_entity_type(Test::Foo)
    assert_equal("bar", et.key_property.name)
  end
  
  # set up a Foo object with the "bar" property as the key
  # the href for the instance should be constructed correctly
  # http://www.odata.org/documentation/odata-v3-documentation/url-conventions/
  def test_href_for_one
    schema = OData::InMemorySchema::Base.new(Test::Foo)
    schema.register(Test::Foo, :bar)
    inst = Test::Foo.new("foo", "3333", "baz")
    et = schema.find_entity_type(Test::Foo)
    et.entities.append(inst)
    assert_equal("Foo(3333)", et.href_for(inst))
  end
end