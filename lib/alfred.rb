require 'alfred/version'
require 'alfred/rails'
require 'alfred/configuration'
require 'alfred/registry'
require 'alfred/definition'
require 'alfred/scenario'
require 'alfred/fixture_file'
require 'alfred/scenario_dsl'
require 'alfred/request'
require 'alfred/runner'
require 'alfred/ui'

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
    #       DatabaseCleaner.clean
    #     end
    #
    #     c.mock_with :rspec
    #
    #     c.fixture_path 'spec/fixtures'
    #   end
    #
    def configure
      yield configuration if block_given?
    end

    ##
    # Loads the configuration.
    #
    def load_configuration!
      Dir["spec/alfred_helper.rb"].each { |f| load f }
      Dir["test/alfred_helper.rb"].each { |f| load f }
    end

    ##
    # Configure mock framework.
    #
    def configure_mock_framework!
      require "alfred/mocking_adapters/#{configuration.mock_with}"
      Request.send(:include, configuration.mock_adapter)
    end

    ##
    # Includes configured modules in Request.
    #
    def include_modules!
      ## Include modules from configuration
      Alfred.configuration.includes.each do |mod|
        Request.send(:include, mod)
      end
    end

    ##
    # Loads the configuration and scenario's.
    #
    def load!
      load_configuration!
      configure_mock_framework!
      include_modules!

      ## Load scenario's
      # :nocov:
      Dir["spec/alfreds/**/*.rb"].each { |f| load f }
      Dir["test/alfreds/**/*.rb"].each { |f| load f }
      # :nocov:
    end

    ##
    # Returns fixture path defined in Configuration.
    #
    def fixture_path
      configuration.fixture_path
    end

  end # class << self

end # Alfred
