# :nocov:

# NOTE: No specs and coverage for Mocha since Mocha is automatically loaded in ActiveSupport::TestCase. It' ruins all rspec stubs for any_instance.
# see: https://github.com/rails/rails/blob/701664b56b69827bfb46a5acfddf81d3a81b5d09/activesupport/lib/active_support/test_case.rb#L14

# In order to support all versions of mocha, we have to jump through some
# hoops here.
#
# mocha >= '0.13.0':
#   require 'mocha/api' is required
#   require 'mocha/object' raises a LoadError b/c the file no longer exists
# mocha < '0.13.0', >= '0.9.7'
#   require 'mocha/api' is required
#   require 'mocha/object' is required
# mocha < '0.9.7':
#   require 'mocha/api' raises a LoadError b/c the file does not yet exist
#   require 'mocha/standalone' is required
#   require 'mocha/object' is required
begin
  require 'mocha/api'

  begin
    require 'mocha/object'
  rescue LoadError
    # Mocha >= 0.13.0 no longer contains this file nor needs it to be loaded
  end
rescue LoadError
  require 'mocha/standalone'
  require 'mocha/object'
end

module Alfred
  module MockingAdapters
    module Mocha

      def self.framework_name; :mocha end

      begin
        include ::Mocha::API
      rescue NameError
        include ::Mocha::Standalone
      end

      def setup_mocks
        mocha_setup
      end

      def teardown_mocks
        mocha_verify
      ensure
        mocha_teardown
      end

    end # Mocha
  end # MockingAdapters
end # Alfred
# :nocov: