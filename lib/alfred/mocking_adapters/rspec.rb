module Alfred
  module MockingAdapters
    module RSpec

      # :nocov:
      def setup_mocks
        ::RSpec::Mocks.setup(self)
      end

      def teardown_mocks
        ::RSpec::Mocks.verify
      ensure
        ::RSpec::Mocks.teardown
      end
      # :nocov:

    end # RSpec
  end # MockingAdapters
end # Alfred
