require 'rr'

module Alfred
  module MockingAdapters
    module RR

      include ::RR::Extensions::InstanceMethods

      def setup_mocks
        ::RR::Space.instance.reset
      end

      def teardown_mocks
        ::RR::Space.instance.verify_doubles
      ensure
        ::RR::Space.instance.reset
      end

    end # RR
  end # MockingAdapters
end # Alfred
