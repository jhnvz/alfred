ENV['RAILS_ENV'] = 'test'

module AlfredRailsTest
  class Application < Rails::Application
    config.active_support.deprecation = :log
    config.secret_token = 'existing secret token'

    if Rails::VERSION::STRING >= "4.0.0"
      config.secret_key_base = 'new secret key base'
    end
  end
end
#AlfredRailsTest::Application.initialize!