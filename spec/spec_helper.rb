require 'fluent/load'
require 'fluent/test'

require 'coveralls'
Coveralls.wear!
# prevent Test::Unit's AutoRunner from executing during RSpec's rake task
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)
