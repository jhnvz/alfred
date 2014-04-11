#  Created by Jim Weirich on 2007-04-10.
#  Copyright (c) 2007. All rights reserved.

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
