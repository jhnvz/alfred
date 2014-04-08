ENV["RAILS_ENV"] ||= 'test'

require "optparse"

module Alfred
  class CommandLine

    def initialize
      @options = {}
      @options[:files] = parse_options

      load!
      ::Alfred::Runner.new(@options[:files])
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

  end # CommandLine
end # Alfred
