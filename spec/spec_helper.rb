## Test coverage

require 'coveralls'
Coveralls.wear!

## Rails

require 'support/application'

## Rspec

require 'rspec'
require 'ammeter/init'
require 'rspec/autorun'

## Load alfred_rails

require 'alfred_rails'

## Make sure registry is empty after each example

RSpec.configure do |config|
  config.after(:each) { Alfred.registry.clear! }
end
