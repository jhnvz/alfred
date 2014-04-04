require 'robin_rails/version'
require 'robin_rails/configuration'
require 'robin_rails/registry'
require 'robin_rails/definition'
require 'robin_rails/scenario'
require 'robin_rails/scenario_proxy'
require 'robin_rails/request'
require 'robin_rails/runner'

require 'active_support'
require 'database_cleaner'

module Robin
  extend Robin::Definition

  class << self

    def registry
      @registry ||= Registry.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    ##
    # Configure Robin.
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
      Dir["spec/robin_configuration.rb"].each { |f| load f }

      ## Load robins
      load_scenarios!
    end

    def load_scenarios!
      Dir["spec/robins/**/*.rb"].each { |f| load f }
    end

    def reload!
      @registry.try(:clear!)
      load_scenarios!
    end

  end

  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "tasks/robin_rails.rake"
      end
    end # Railtie
  end # Rails

end #Robin
