module Alfred
  module Definition

    ##
    # Defines a new Alfred scenario.
    #
    # === Params
    #
    # [block (Block)] the block to perform
    #
    # === Examples
    #
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
    #
    #     scenario 'update post by manager' do
    #       controller Api::V1::PostsController
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
      # === Params
      #
      # [name (Symbol)] the name of the scenario
      # [block (Block)] the block to perform
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
      # === Params
      #
      # [controller (ActionController::Base)] the controller
      # [block (Block)] the block to perform
      #
      def controller(controller, &block)
        Thread.current[:controller] = controller

        instance_eval(&block)
      end

      ##
      # Define setup for every scenario.
      #
      # === Params
      #
      # [block (Block)] the block to setup on Alfred Scenario
      #
      # === Examples
      #
      #   Alfred.define do
      #     setup do
      #       SomeController.stub(:current_user).and_return(create(:user))
      #     end
      #
      #     scenario 'alfred is awesome' do
      #
      #     end
      #   end
      #
      def setup(&block)
        Thread.current[:setup] << block
      end

      ##
      # Runs the code inside a block.
      #
      # === Params
      #
      # [block (Block)] the block to run
      #
      # === Examples
      #
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
