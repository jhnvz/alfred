module Alfred
  class UI

    class << self

      ##
      # Display info via STDOUT.
      #
      # === Params
      #
      # [message (String)] the message to display.
      # [options (Hash)] optional options hash.
      #
      # === Example
      #
      #   UI.info('Alfred generated the following fixtures:')
      #   #=>  07:46:28 - INFO - Alfred generated the following fixtures:
      #
      def info(message, options={})
        new(options).queue(message, :timestamp => true).display
      end

    end # class << self

    attr_accessor :message, :options

    def initialize(options={})
      @message = []
      @options = options
    end

    ##
    # Add a message to the queue.
    #
    # === Params
    #
    # [message (String)] the message to queue
    # [options (Hash)] display timestamp
    #
    # === Example
    #
    #   message = UI.new
    #   message.queue('Alfred generated the following fixtures:', :timestamp => true)
    #
    # Will add the following string to the queue:
    #
    #   '07:46:28 - INFO - Alfred generated the following fixtures:'
    #
    # Insert at the begin of the queue
    #
    #   message = Ui.new
    #   message.queue('/spec/some_file.rb')
    #   message.queue('Generated:', :timestamp => true, :before => true)
    #
    # Queue will look like:
    #
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
      # === Example
      #
      #   ui.timestamp #=> '07:46:28 - INFO - '
      #
      def timestamp
        "#{Time.now.strftime('%H:%M:%S')} - INFO - "
      end

  end # UI
end # Alfred
