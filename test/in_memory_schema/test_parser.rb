require 'helper'

class TestParser < Test::Unit::TestCase
  def test_parser
    data_services = OData::Edm::DataServices.new
    parser = OData::Core::Parser.new(data_services)
    schema = OData::InMemorySchema::Base.new
    schema.register(Test::Foo)
    data_services.schemas << schema
    a = parser.parse! "Foo?$filter=Prop eq 5"
    filter_option = a.options.find { |o| o.option_name == OData::Core::Options::FilterOption.option_name }
    assert_equal("Prop eq 5", filter_option.value)
  end
end