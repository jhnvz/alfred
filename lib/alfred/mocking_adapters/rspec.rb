module Alfred
  module MockingAdapters
    module RSpec

      include ::RSpec::Mocks::ExampleMethods

      def self.framework_name; :rspec end

      def setup_mocks
        ::RSpec::Mocks.setup(Object)
      end

      def verify_mocks
        ::RSpec::Mocks.verify(Object)
      end

      def teardown_mocks
        ::RSpec::Mocks.teardown
      end

    end # RSpec
  end # MockingAdapters
end # Alfred
