module Alfred
  module MockingAdapters
    module RSpec

      def self.framework_name; :rspec end

      def setup_mocks
        ::RSpec::Mocks.setup(self)
      end

      def teardown_mocks
        ::RSpec::Mocks.verify
      ensure
        ::RSpec::Mocks.teardown
      end

    end # RSpec
  end # MockingAdapters
end # Alfred
