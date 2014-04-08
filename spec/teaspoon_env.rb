require File.expand_path('../support/application', __FILE__)
require 'teaspoon'

Teaspoon.setup do |config|
  config.mount_at     = '/teaspoon'
  config.root         = nil
  config.asset_paths  = ['spec/javascripts']

  config.suite do |suite|
    suite.javascripts = ['teaspoon-mocha']
  end

end if defined?(Teaspoon) && Teaspoon.respond_to?(:setup) # let Teaspoon be undefined outside of development/test/asset groups
