require 'ruby-progressbar'

module Alfred
  class Runner

    attr_accessor :files, :controllers, :matches, :scenarios

    ##
    # Initialize a new runner and find and run scenario's.
    # Runs al scenarios if files are empty.
    #
    # === Params
    #
    # [files (Array)] the files to lookup
    #
    # === Example
    #
    # Run specific scenario's:
    #
    #   Runner.new(['spec/alfreds/some_controller.rb'])
    #   #=> Will run scenario's for some_controller
    #
    # Run all scenario's:
    #
    #   Runner.new
    #   #=> Will run all scenario's
    #
    def initialize(files=[])
      @files       = files
      @controllers = controllers_for_files
      @matches     = matches_for_controllers
      @scenarios   = scenarios_for_controllers

      run if @scenarios.any?
    end

    private

      ##
      # Returns controller_names for files in @files.
      #
      def controllers_for_files
        if @files.any?
          @files.map do |file|
            file
              .gsub('.rb', '')
              .gsub("#{::Alfred.configuration.test_path}/alfreds/", '')
          end
        end
      end

      ##
      # Returns registered scenarios for @controllers.
      # Returns all scenarios if @controllers is nil.
      #
      def scenarios_for_controllers
        if @controllers
          scenarios = []
          @controllers.each do |controller|
            scenarios << Alfred.registry[controller]
          end
          scenarios.flatten.compact
        else
          Alfred.registry.all
        end
      end

      ##
      # Returns controllers found in registry.
      #
      def matches_for_controllers
        if @controllers
          matches = []
          @controllers.each do |controller|
            if Alfred.registry.registered?(controller)
              matches << "#{Alfred.configuration.test_path}/alfreds/#{controller}.rb"
            end
          end
          matches
        end
      end

      ##
      # Display runner start message.
      #
      def start_message
        message = @matches ? @matches.join(' ') : "all scenario's"
        UI.info("Alfred: Serving #{message}", :empty_line_before => true)
      end

      ##
      # Run scenarios defined in @scenarios
      #
      def run
        #Alfred.registry.clear!

        start_message

        progress = ProgressBar.create(
          :starting_at => 0,
          :format      => '%c/%C: |%B| %a',
          :total       => @scenarios.size
        )

        message = UI.new(:empty_line_before => true, :empty_line_after => true)

        @scenarios.each do |scenario|
          scenario.run # Run the scenario
          progress.increment # Increment progressbar
          message.queue(scenario.file.filename) # Add filename to the message queue
          #@scenarios.delete(scenario)
        end

        message.queue('Alfred served the following fixtures:', :timestamp => true, :before => true)
        message.display
      end

  end # Runner
end # Alfred
