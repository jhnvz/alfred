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
        ::Guard::UI.info("Running all Robin scenario's\n", :reset => true)

        ::Robin::Runner.new
      end

      def run(paths)
        return true if paths.empty?
        ::Guard::UI.info("Robin is looking for: #{paths.join(' ')}\n", :reset => true)

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