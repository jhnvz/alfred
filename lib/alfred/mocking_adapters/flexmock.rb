#  Created by Jim Weirich on 2007-04-10.
#  Copyright (c) 2007. All rights reserved.

require 'flexmock/rspec'

module Alfred
  module MockingAdapters
    module Flexmock

      include ::FlexMock::MockContainer

      def self.framework_name; :flexmock end

      def setup_mocks
        # No setup required
      end

      def verify_mocks
        flexmock_verify
      end

      def teardown_mocks
        flexmock_close
      end

    end # Flexmock
  end # MockingAdapters
end # Alfred
