ENV["RAILS_ENV"] ||= 'test'

require "optparse"

module Alfred
  class CommandLine

    def initialize
      @options = {}
      @options[:files] = parse_options

      load_rails

      ::Alfred.load!

      STDOUT.print("Alfred: Running all scenario's\n")

      ::Alfred::Runner.new(@options[:files])
    end

    def parse_options
      options = {}
      OptionParser.new do |options|
        options.banner = "Usage: alfred [options] [files]\n"

        options.on "-v", "--version", "Display the version.", proc {
          STDOUT.print("#{AlfredRails::VERSION}\n")
          exit
        }

        options.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          @options[:verbose] = v
        end
      end.parse!
    end

    def load_rails
      load 'config/application.rb'
      ::Rails.application.initialize!
      require 'alfred_rails'
    end

    def abort(message = nil)
      STDOUT.print(message) if message
      exit(1)
    end

  end
end
