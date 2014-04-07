require 'rails/all'

module Rails
  class Application
    class Configuration
      def database_configuration
        YAML::load File.read('spec/fixtures/database.yml')
      end
    end
  end
end

## Load support files

load 'spec/support/rails.rb'
load 'spec/support/routes.rb'
load 'spec/support/schema.rb'

[:controllers, :models, :lib].each do |dir|
  Dir["spec/support/#{dir}/**/*.rb"].each { |f| load f }
end
