ENV['RAILS_ENV'] = 'test'

module AlfredRailsTest
  class Application < Rails::Application
    config.active_support.deprecation = :log
    config.secret_token = '8f62080da9dd946a6555635c46fbebfb'

    if Rails::VERSION::STRING >= "4.0.0"
      config.secret_key_base = '8f62080da9dd946a6555635c46fbebfb'
    end
  end
end
#AlfredRailsTest::Application.initialize!