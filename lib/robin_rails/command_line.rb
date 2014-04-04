ENV["RAILS_ENV"] ||= 'test'

require "optparse"

module Robin
  class CommandLine

    def initialize
      @options = {}
      @options[:files] = parse_options

      load_rails

      ::Robin.load!

      STDOUT.print("Robin: Running all scenario's\n")

      ::Robin::Runner.new(@options[:files])
    end

    def parse_options
      options = {}
      OptionParser.new do |options|
        options.banner = "Usage: robin [options] [files]\n"

        options.on "-v", "--version", "Display the version.", proc {
          STDOUT.print("#{RobinRails::VERSION}\n")
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
      require 'robin_rails'
    end

    def abort(message = nil)
      STDOUT.print(message) if message
      exit(1)
    end

  end
end
