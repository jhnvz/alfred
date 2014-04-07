require 'rails/generators'
require 'alfred_rails'

module Alfred
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      ##
      # Define method for checking presence of a module.
      #
      # === Examples
      #
      #   INCLUDES = [{ :class_name => 'Devise', :include => 'Devise::TestHelpers' }]
      #
      #   Will define the following method:
      #
      #   def devise_enabled?
      #     defined?(Devise)
      #   end
      #
      INCLUDES = [
        { :class_name => 'Devise',      :include => 'Devise::TestHelpers' },
        { :class_name => 'FactoryGirl', :include => 'FactoryGirl::Syntax::Methods' }
      ]

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def create_alfred_helper
        template "alfred_helper.erb", "#{test_path}/alfred_helper.rb"
      end

      private

        INCLUDES.each do |mod|
          define_method("#{mod[:class_name].underscore}_defined?") do
            defined?(mod[:class_name].constantize)
          end
        end

        ##
        # Tries to include modules defined in INCLUDES.
        #
        # === Examples
        #
        #   INCLUDES = [{ :class_name => 'Devise', :include => 'Devise::TestHelpers' }]
        #
        #   # Will include: "config.include Devise::TestHelpers"
        #
        def includes
          includes = []
          INCLUDES.each do |mod|
            includes << "config.include #{mod[:include]}" if send("#{mod[:class_name].underscore}_defined?")
          end
          includes
        end

        def mock_with
          Alfred.configuration.mock_with
        end

        def test_path
          Alfred.configuration.test_path
        end

    end # InstallGenerator
  end # Generators
end # Alfred
