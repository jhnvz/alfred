module Alfred
  class Request < ActionController::TestCase

    ##
    # Runs setup block before it runs the controller action.
    #
    # [block (Block)] the block to execute
    #
    # === Example
    #
    #   request = Alfred::Request.new('test')
    #   request.perform_setup do
    #     User.create(:name => 'John Doe')
    #   end
    #
    def perform_setup(&block)
      instance_exec(&block) if block_given?
    end

    ##
    # Sets the controller instance to test.
    #
    # === Params
    #
    # [controller_instance (ActionController::Base#new)] the controller to test
    #
    # === Example
    #
    #   request = Alfred::Request.new('test')
    #   request.set_controller(Api::V1::UsersController)
    #
    def set_controller(controller)
      @routes     = ::Rails.application.routes
      @controller = controller.new
    end

  end # Request
end # Alfred
