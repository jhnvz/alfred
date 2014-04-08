require 'rails/generators'
require 'alfred_rails'

module Alfred
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      ##
      # Define method for checking presence of a module.
      # Will also include module in config.
      #
      # === Examples
      #
      #   INCLUDES = [{ :class_name => 'Devise', :include => 'Devise::TestHelpers' }]
      #
      # Will define the following method:
      #
      #   def devise_enabled?
      #     defined?(Devise)
      #   end
      #
      # Adds the following code to config:
      #
      #   config.include Devise::TestHelpers
      #
      # === Current value:
      #
      INCLUDES = [
        {
          :class_name => 'Devise',
          :include    => 'Devise::TestHelpers'
        }, {
          :class_name => 'FactoryGirl',
          :include    => 'FactoryGirl::Syntax::Methods'
        }
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

        def includes
          includes = []
          INCLUDES.each do |mod|
            if send("#{mod[:class_name].underscore}_defined?")
              includes << "config.include #{mod[:include]}"
            end
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
