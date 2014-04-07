## Test coverage

require 'coveralls'
Coveralls.wear!

## Rails

require 'rails/all'

## Setup fixture database for activerecord

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => File.dirname(__FILE__) + "/fixtures/db/alfred_rails.sqlite3"
)

## Load support files

load 'spec/support/rails.rb'
load 'spec/support/routes.rb'
load 'spec/support/schema.rb'

[:controllers, :models, :lib].each do |dir|
  Dir["spec/support/#{dir}/**/*.rb"].each { |f| load f }
end

## Rspec

require 'rspec'
require 'rspec/autorun'

## Load alfred_rails

require 'alfred_rails'
