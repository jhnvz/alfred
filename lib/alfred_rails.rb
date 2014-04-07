require 'alfred_rails/version'
require 'alfred_rails/configuration'
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

    def registry
      @registry ||= Registry.new
    end

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
    #     c.include Devise::TestHelpers, :controller
    #
    #     c.before do
    #       # Do not use multi-tenancy in tests
    #       Apartment::Database.stub(:create).and_return(true)
    #       Apartment::Database.stub(:switch).and_return(true)
    #       Apartment::Database.stub(:drop).and_return(true)
    #     end
    #   end
    #
    def configure
      yield configuration if block_given?
    end

    def load!
      ## Load configuration
      Dir["spec/alfred_helper.rb"].each { |f| load f }

      ## Load robins
      load_scenarios!
    end

    def load_scenarios!
      Dir["spec/alfreds/**/*.rb"].each { |f| load f }
    end

    def reload!
      @registry.try(:clear!)
      load_scenarios!
    end

    def fixture_path
      "#{::Rails.root}/spec/fixtures"
    end

  end

  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "tasks/alfred_rails.rake"
      end
    end # Railtie
  end # Rails

end # Alfred
