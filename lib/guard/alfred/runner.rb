module Guard
  class Alfred
    class Runner

      attr_accessor :options

      def initialize(options = {})
        @options = options
      end

      ##
      # Runs all the scenario's
      #
      def run_all
        ::Guard::UI.info("Running all Alfred scenario's\n", :reset => true)

        Bundler.with_clean_env { Kernel.system('bundle exec alfred') }
      end

      ##
      # Find scenario's by controller paths.
      #
      def run(paths)
        return true if paths.empty?
        ::Guard::UI.info("Alfred is looking for: #{paths.join(' ')}\n", :reset => true)

        Bundler.with_clean_env { Kernel.system("bundle exec alfred #{paths.join(' ')}") }
      end

    end # Runner
  end # Alfred
end # Guard
