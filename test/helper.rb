require 'rubygems'

ENV["RAILS_ENV"] ||= "test"
require 'rails'
require 'rails/test_help'
require 'test/unit'
require 'byebug'

def MiniTest.filter_backtrace(bt)
  bt
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'odata_server'

module Test
  class Foo
    attr_reader :foo, :bar, :baz
    
    def initialize(foo, bar, baz)
      @foo = foo
      @bar = bar
      @baz = baz
    end
  end
end