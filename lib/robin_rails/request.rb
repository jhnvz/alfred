module RobinRails
  class Request < ActionController::TestCase

    ##
    # Runs setup block before it runs the controller action.
    #
    # [block (Block)] the block to execute
    #
    # === Example
    #
    # request = RobinRails::Request.new('test')
    # request.setup do
    #   User.create(:name => 'John Doe')
    # end
    #
    def setup(&block)
      @routes = Rails.application.routes

      instance_eval(&block)
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
    # request = RobinRails::Request.new('test')
    # request.set_controller(Api::V1::UsersController.new)
    #
    def set_controller(controller_instance)
      @controller = controller_instance
    end

  end # Request
end # RobinRails
