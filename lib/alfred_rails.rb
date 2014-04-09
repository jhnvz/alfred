require 'alfred_rails/version'
require 'alfred_rails/rails'
require 'alfred_rails/configuration'
require 'alfred_rails/mock'
require 'alfred_rails/registry'
require 'alfred_rails/definition'
require 'alfred_rails/scenario'
require 'alfred_rails/fixture_file'
require 'alfred_rails/scenario_dsl'
require 'alfred_rails/request'
require 'alfred_rails/runner'
require 'alfred_rails/ui'

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
    # Loads the configuration
    #
    def load_configuration!
      Dir["spec/alfred_helper.rb"].each { |f| load f }
      Dir["test/alfred_helper.rb"].each { |f| load f }
    end

    ##
    # Loads the configuration and scenario's
    #
    def load!
      load_configuration!

      ## Load scenario's
      Dir["spec/alfreds/**/*.rb"].each { |f| load f }
      Dir["test/alfreds/**/*.rb"].each { |f| load f }

      ## Include modules from configuration
      Alfred.configuration.includes.each do |mod|
        Request.send(:include, mod)
      end
    end

    ##
    # Returns fixture path defined in Configuration.
    #
    def fixture_path
      configuration.fixture_path
    end

  end # class << self

end # Alfred
