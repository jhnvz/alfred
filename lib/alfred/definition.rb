module Alfred
  ##
  # Definition logic.
  #
  module Definition

    ##
    # Defines a new Alfred scenario.
    #
    # @param block [Proc] the block to perform
    # @example
    #   Alfred.define do
    #     setup do
    #       sign_in :user, create(:user)
    #     end
    #
    #     controller Api::V1::PostsController do
    #       scenario 'update post by manager' do
    #         setup do
    #           create(:poset, :title => 'Alfred is awesome', :body => 'It saves me time')
    #         end
    #
    #         patch :update, {
    #           :format => :json,
    #           :id     => 1,
    #           :post   => {
    #             :title => 'Alfred rocks!'
    #           }
    #         }
    #       end
    #     end
    #   end
    #
    def define(&block)
      Thread.current[:controller] = nil
      Thread.current[:setup]      = []

      DSL.run(block)
    end

    class DSL

      ##
      # Define a new scenario.
      #
      # @param name [Symbol] the name of the scenario
      # @param block [Proc] the block to perform on scenario dsl
      #
      def scenario(name, &block)
        scenario            = Scenario.new(name)
        scenario.controller = Thread.current[:controller]

        Thread.current[:setup].each { |setup| scenario.setups << setup }

        dsl = ScenarioDSL.new(scenario)
        dsl.instance_eval(&block) if block_given?

        Alfred.registry.register(scenario.controller_name, scenario)
      end

      ##
      # Define the controller.
      #
      # @param controller [ActionController::Base] the controller
      # @param block [Proc] the block to perform
      #
      def controller(controller, &block)
        Thread.current[:controller] = controller

        instance_eval(&block)
      end

      ##
      # Define setup for every scenario.
      #
      # @param block [Proc] the block to setup on Alfred Scenario
      # @example
      #   Alfred.define do
      #     setup do
      #       SomeController.stub(:current_user).and_return(create(:user))
      #     end
      #
      #     scenario 'alfred is awesome'
      #   end
      #
      def setup(&block)
        Thread.current[:setup] << block
      end

      ##
      # Runs the code inside a block.
      #
      # @param block [Proc] the block to run
      # @example
      #   new.run do
      #     setup do
      #       User.create(:name => 'John Doe')
      #     end
      #   end
      #
      #   #=> Will call the setup method with a new block
      #
      def self.run(block)
        new.instance_eval(&block)
      end

    end # DSL

  end # Definition
end # Alfred
