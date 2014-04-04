module Guard
  class Robin
    class Runner
      attr_accessor :options

      def initialize(options = {})
        @options = options

        load_rails!

        ::Robin.load!
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
        ::Robin.reload!
      end

      def load_rails!
        unless ::Rails.application
          load 'config/application.rb'
          Rails.application.initialize!
        end
        require 'robin_rails'
      end
    end
  end
end