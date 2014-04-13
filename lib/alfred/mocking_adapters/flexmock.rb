require 'flexmock/rspec'

module Alfred
  module MockingAdapters
    module Flexmock

      include ::FlexMock::MockContainer

      def setup_mocks
        # No setup required
      end

      def teardown_mocks
        flexmock_verify
      ensure
        flexmock_close
      end

    end # Flexmock
  end # MockingAdapters
end # Alfred
