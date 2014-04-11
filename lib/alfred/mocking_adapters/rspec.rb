module Alfred
  module MockingAdapters
    module RSpec

      def self.framework_name; :rspec end

      def setup_mocks
        ::RSpec::Mocks.setup(Object)
      end

      def verify_mocks
        ::RSpec::Mocks.verify
      end

      def teardown_mocks
        ::RSpec::Mocks.teardown
      end

    end # RSpec
  end # MockingAdapters
end # Alfred
