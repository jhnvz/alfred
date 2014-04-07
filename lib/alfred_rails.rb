require 'alfred_rails/version'
require 'alfred_rails/configuration'
require 'alfred_rails/mock'
require 'alfred_rails/registry'
require 'alfred_rails/definition'
require 'alfred_rails/scenario'
require 'alfred_rails/scenario_dsl'
require 'alfred_rails/request'
require 'alfred_rails/runner'

require 'active_support'
require 'database_cleaner'

module Alfred
  extend Alfred::Definition

  class << self

    ##
    # Builds registry or returns existing registry.
    #
    # === Returns
    #
    # [registry (Alfred::Registry)] the registry
    #
    def registry
      @registry ||= Registry.new
    end

    ##
    # Builds configuration or returns existing configuration.
    #
    # === Returns
    #
    # [configuration (Alfred::Configuration)] the configuration instance
    #
    def configuration
      @configuration ||= Configuration.new
    end

    ##
    # Configure Alfred.
    #
    # === Example
    #
    #   configure do |c|
    #     c.include FactoryGirl::Syntax::Methods
    #     c.include Devise::TestHelpers
    #
    #     c.before do
    #       # Do not use multi-tenancy in tests
    #       Apartment::Database.stub(:create).and_return(true)
    #       Apartment::Database.stub(:switch).and_return(true)
    #       Apartment::Database.stub(:drop).and_return(true)
    #     end
    #
    #     c.mock_with :rspec
    #     c.fixture_path 'spec/fixtures'
    #   end
    #
    def configure
      yield configuration if block_given?
    end

    ##
    # Loads the scenario's
    #
    def load!
      ## Load configuration
      Dir["spec/alfred_helper.rb"].each { |f| load f }

      ## Load scenario's
      Dir["spec/alfreds/**/*.rb"].each { |f| load f }
    end

    ##
    # Returns fixture path defined in Configuration.
    #
    def fixture_path
      configuration.fixture_path
    end

  end # class << self

  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "tasks/alfred.rake"
      end
    end # Railtie
  end # Rails

end # Alfred
