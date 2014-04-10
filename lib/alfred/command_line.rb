ENV["RAILS_ENV"] ||= 'test'

require "optparse"
require 'method_profiler'

module Alfred
  class CommandLine

    def initialize
      @options = {}
      @options[:files] = parse_options

      load_rails!

      require 'alfred'

      alfred        = MethodProfiler.observe(::Alfred)
      configuration = MethodProfiler.observe(::Alfred::Configuration)
      definition    = MethodProfiler.observe(::Alfred::Definition)
      scenario_dsl  = MethodProfiler.observe(::Alfred::ScenarioDSL)
      scenario      = MethodProfiler.observe(::Alfred::Scenario)
      fixture_file  = MethodProfiler.observe(::Alfred::FixtureFile)
      registry      = MethodProfiler.observe(::Alfred::Registry)
      request       = MethodProfiler.observe(::Alfred::Request)
      runner        = MethodProfiler.observe(::Alfred::Runner)
      ui            = MethodProfiler.observe(::Alfred::UI)

      ::Alfred.load!
      ::Alfred::Runner.new(@options[:files])

      ::Alfred::UI.info(alfred.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(configuration.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(definition.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(scenario_dsl.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(scenario.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(fixture_file.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(registry.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(request.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(runner.report.to_s, :empty_line_before => true)
      ::Alfred::UI.info(ui.report.to_s, :empty_line_before => true)
    end

    ##
    # Add abort method in case input is aborted.
    #
    # :nocov:
    def abort(message = nil)
      STDOUT.print(message) if message
      exit(1)
    end
    # :nocov:

    private

      ##
      # Parses the options and returns the files if present.
      #
      # === Returns
      #
      # [files (Array)] the files to run
      #
      def parse_options
        options = {}
        OptionParser.new do |options|
          options.banner = "Usage: alfred [options] [files]\n"

          options.on "-v", "--version", "Display the version.", proc {
            STDOUT.print("#{Alfred::VERSION}\n")
            exit
          }
        end.parse!
      end

      ##
      # Load Rails environment and Alfred.
      #
      # :nocov:
      def load_rails!
        load 'config/application.rb'
        ::Rails.application.initialize!
      end
      # :nocov:

  end # CommandLine
end # Alfred
