require 'helper'

class TestFilterOption < Test::Unit::TestCase
  def test_tokenize_handles_integer_literals
    tokens = OData::Core::Options::FilterOption.tokenize_filter_query("Prop eq 55")
    assert_equal(3, tokens.length)
    assert_equal("55", tokens[2])
    # handle negative number
    tokens = OData::Core::Options::FilterOption.tokenize_filter_query("Prop eq -55")
    assert_equal(3, tokens.length)
    assert_equal("-55", tokens[2])
  end

  def test_tokenize_handles_decimal_literals
    tokens = OData::Core::Options::FilterOption.tokenize_filter_query("Prop eq 55.3")
    assert_equal(3, tokens.length)
  end
  
  def test_tokenize_handles_string_literals
    tokens = OData::Core::Options::FilterOption.tokenize_filter_query("Prop eq 'string'")
    assert_equal(3, tokens.length)
    assert_equal("'string'", tokens[2])
  end
  
  def test_parse_filter_query
    filters = OData::Core::Options::FilterOption.parse_filter_query("Prop eq 5")
    assert_equal(3, filters.size)
    assert_equal(:eq, filters.value)
    assert_equal("Prop", filters.left.value)
    assert_equal("5", filters.right.value)
  end
  
  # test token grouping (for handling parentheses)
  # def test_group_tokens
    # tokens = OData::Core::Options::FilterOption.tokenize_filter_query("(Foo eq 1 and Bar eq 2) or (Baz eq 3 and Bar eq 4)")
    # filters = OData::Core::Options::FilterOption.group_tokens(tokens)
    # assert_equal(3, filters.size)
  # end
   
  # we organize the tokens into a tree with the highest precendence operators at the bottom of the tree (so they will
  # be evaluated first)
  def test_tree_tokens
    # eq has highest precedence, followed by and, then finally or
    tokens = OData::Core::Options::FilterOption.tokenize_filter_query("a or c eq d and e eq f")
    tree = OData::Core::Options::FilterOption.tree_tokens(tokens)
    assert_equal(9, tree.size, "incorrect size for token tree")
    assert_equal(5, tree.left.size, "left-hand side should have only one node")
    assert_equal(:and, tree.value, "wrong value for root")
    assert_equal(:eq, tree.right.value, "wrong value for root")
  end
  
  def test_find_filter
    schema = OData::AbstractSchema::Base.new
    ds = OData::Edm::DataServices.new([schema])
    entity_type = schema.EntityType("Foo")
    bar = entity_type.Property("bar", 'Edm.Int32', false)
    entity_type.Property("baz", 'Edm.Int32', false)
    entity_type.key_property = bar 
    query = OData::Core::Parser.new(ds).parse!("Foos")
    filter = "bar add 5 eq 8 or baz eq 3"
    # head should be :or
    filter_option = OData::Core::Options::FilterOption.new(query, filter)
    expr = filter_option.find_filter(:baz)
    assert_not_nil(expr)
    assert_equal('3', expr.value)
    assert_equal(:baz, expr.property)
    assert_equal(:eq, expr.operator)
  end
  
  def test_apply_filter
    schema = OData::AbstractSchema::Base.new
    ds = OData::Edm::DataServices.new([schema])
    entity_type = schema.EntityType("Foo")
    bar = entity_type.Property("bar", 'Edm.Int32', false)
    entity_type.Property("baz", 'Edm.Int32', false)
    entity_type.key_property = bar 
    query = OData::Core::Parser.new(ds).parse!("Foos")
    filter = "bar add 5 eq 8 or baz eq 3"
    # head should be :or
    filter_option = OData::Core::Options::FilterOption.new(query, filter)
    assert_equal(:or, filter_option.filter.value)
    assert_equal(:eq, filter_option.filter.right.value)
    assert_equal('baz', filter_option.filter.right.left.value)
    assert_equal('3', filter_option.filter.right.right.value)
    entity = Test::Foo.new(1, 2, 4)
    res = filter_option.apply(entity_type, entity)
    assert(!res)
    entity = Test::Foo.new(1, 3, 4)
    res = filter_option.apply(entity_type, entity)
    assert(res)
  end
end