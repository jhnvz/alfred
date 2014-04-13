ENV["RAILS_ENV"] ||= 'test'

require "optparse"

module Alfred
  ##
  # Run Alfred as a binary.
  #
  class CommandLine

    def initialize
      @options = {}
      @options[:files] = parse_options

      load_rails!

      require 'alfred'
      ::Alfred.load!

      ::Alfred::Runner.new(@options[:files])
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
      # @return [Array] the files to run
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
      # Load Rails environment.
      #
      # :nocov:
      def load_rails!
        load 'config/application.rb'
        ::Rails.application.initialize!
      end
      # :nocov:

  end # CommandLine
end # Alfred
