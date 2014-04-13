module Alfred
  ##
  # Responsible for queueing and displaying message through STDOUT.
  #
  class UI

    class << self

      ##
      # Display info via STDOUT.
      #
      # @param message [String] the message to display
      # @param options [Hash] optional options hash
      # @option options [true|false] :empty_line_before display empty line before message
      # @option options [true|false] :empty_line_after display empty line after message
      # @example
      #   UI.info('Alfred generated the following fixtures:')
      #   #=>  07:46:28 - INFO - Alfred generated the following fixtures:
      #
      def info(message, options={})
        new(options).queue(message, :timestamp => true).display
      end

    end # class << self

    attr_accessor :message, :options

    ##
    # Initialize a new UI message
    #
    # @param options [Hash] optional options hash
    # @option options [true|false] :empty_line_before display empty line before message
    # @option options [true|false] :empty_line_after display empty line after message
    #
    def initialize(options={})
      @message = []
      @options = options
    end

    ##
    # Add a message to the queue.
    #
    # @param message [String] the message to queue
    # @param options [Hash] optinal options hash
    # @option options [true|false] :timestamp whether to insert a timestamp
    # @option options [true|false] :before whether to insert message at the beginning of the queue
    # @example
    #   message = UI.new
    #   message.queue('Alfred generated the following fixtures:', :timestamp => true)
    #
    #   # Will add the following string to the queue:
    #   '07:46:28 - INFO - Alfred generated the following fixtures:'
    #
    # @example Insert at the begin of the queue
    #   message = Ui.new
    #   message.queue('/spec/some_file.rb')
    #   message.queue('Generated:', :timestamp => true, :before => true)
    #
    #   # Queue will look like:
    #   message.message #=> ["07:46:28 - INFO - Generated:\n", "/spec/some_file.rb\n"]
    #
    def queue(message, options={})
      message  = "#{timestamp}#{message}" if options[:timestamp]
      position = options[:before] ? 0 : -1
      @message.insert(position, "#{message}\n")
      return self
    end

    ##
    # Display the message.
    #
    def display
      @message.insert(0, "\n")  if @options[:empty_line_before]
      @message.insert(-1, "\n") if @options[:empty_line_after]

      STDOUT.print(@message.join)
    end

    private

      ##
      # Returns a timestamp info string.
      #
      def timestamp
        "#{Time.now.strftime('%H:%M:%S')} - INFO - "
      end

  end # UI
end # Alfred
