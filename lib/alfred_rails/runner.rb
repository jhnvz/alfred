require 'ruby-progressbar'

module Alfred
  class Runner

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
    #   Runner.new(['spec/alfreds/some_controller.rb'])
    #   #=> Will run scenario's for some_controller
    #
    #   Runner.new
    #   #=> Will run all scenario's
    #
    def initialize(files=[])
      @files             = files
      @controllers       = controllers_for_files
      @found_controllers = found_controllers
      @scenarios         = scenarios_for_controllers

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
      def found_controllers
        if @controllers
          found = []
          @controllers.each do |controller|
            if Alfred.registry.registered?(controller)
              found << "#{Alfred.configuration.test_path}/alfreds/#{controller}.rb"
            end
          end
          found
        end
      end

      def start_message
        message = @found_controllers ? @found_controllers.join(' ') : "all scenario's"
        UI.info("Alfred: Running #{message}", :empty_line_before => true)
      end

      ##
      # Run scenarios defined in @scenarios
      #
      def run
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
        end

        message.queue('Alfred generated the following fixtures:', :timestamp => true, :before => true)
        message.display
      end

  end # Runner
end # Alfred
