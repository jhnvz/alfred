require 'alfred'

module Alfred
  module Generators
    class ControllerGenerator < ::Rails::Generators::NamedBase

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def create_scenario
        Alfred.load_configuration!
        template 'alfred.erb', "#{test_path}/alfreds/#{class_name.underscore}_controller.rb"
      end

      private

        def test_path
          Alfred.configuration.test_path
        end

    end # ControllerGenerator
  end # Generators
end # Alfred
