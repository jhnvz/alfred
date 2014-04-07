ENV["RAILS_ENV"] ||= 'test'

require "optparse"

module Alfred
  class CommandLine

    def initialize
      @options = {}
      @options[:files] = parse_options

      load!
      STDOUT.print(message)
      ::Alfred::Runner.new(@options[:files])
    end

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
    def load!
      load 'config/application.rb'
      ::Rails.application.initialize!

      require 'alfred_rails'
      ::Alfred.load!
    end

    ##
    # Add abort method in case input is aborted.
    #
    def abort(message = nil)
      STDOUT.print(message) if message
      exit(1)
    end

    private

      ##
      # Displays a message about which controllers are run.
      #
      def message
        message = @options[:files].empty? ? "all scenario's" : @options[:files].join(' ')
        "#{Time.now.strftime('%H:%M:%S')} - INFO - Alfred: Running #{message}\n"
      end

  end # CommandLine
end # Alfred
