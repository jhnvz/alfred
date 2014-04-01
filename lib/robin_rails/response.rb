module RobinRails
  class Response < ActionController::TestCase

    ##
    # Runs setup block before it runs the controller action.
    #
    # === Example
    #
    # response = RobinRails::Response.new('test')
    # response.setup do
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
    # === Example
    #
    # response = RobinRails::Response.new('test')
    # response.set_controller(Api::V1::UsersController.new)
    #
    def set_controller(controller_instance)
      @controller = controller_instance
    end

  end # Response
end # RobinRails
