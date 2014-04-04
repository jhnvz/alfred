module Guard
  class Robin
    class Runner
      attr_accessor :options

      def initialize(options = {})
        @options = options

        load_rails!

        ::Robin.reload!
      end

      def run_all
        ::Guard::UI.info("Running all scenario's", :reset => true)

        ::Robin::Runner.new
      end

      def run(paths)
        return true if paths.empty?
        ::Guard::UI.info("Looking for: #{paths.join(' ')}", :reset => true)

        ::Robin::Runner.new(paths)
      end

      def reload
        Robin.reload!
      end

      def load_rails!
        load 'config/application.rb'
        Rails.application.initialize!
        require 'robin_rails'
      end
    end
  end
end