require 'rubygems'

ENV["RAILS_ENV"] ||= "test"
require 'rails'
require 'rails/test_help'
require 'test/unit'

def MiniTest.filter_backtrace(bt)
  bt
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'odata_server'

