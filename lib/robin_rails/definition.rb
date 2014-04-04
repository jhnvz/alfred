module Robin
  module Definition

    ##
    # Defines a new Robin scenario.
    #
    # === Params
    #
    # [block (Block)] the block to perform
    #
    # === Examples
    #
    #   Robin.define do
    #     controller Api::V1::PostsController do
    #       scenario 'update post by manager' do
    #         setup do
    #           User.create(:name => 'John Doe', :permissions => { :manager => true })
    #           Post.create(:title => 'Robin is awesome', :body => 'It saves me time')
    #         end
    #
    #         patch :update, {
    #           :format => :json,
    #           :id     => 1,
    #           :post   => {
    #             :title => 'Robin rocks!'
    #           }
    #         }
    #     end
    #   end
    #
    #   Robin.define do
    #     scenario 'update post by manager' do
    #       controller Api::V1::PostsController
    #
    #       etc
    #     #
    #   end
    #
    def define(&block)
      DSL.run(block)
    end

    class DSL

      ##
      # Define a new robin.
      #
      # === Params
      #
      # [name (Sym)] the name of the scenario
      # [block (Block)] the block to perform
      #
      def scenario(name, &block)
        scenario            = Scenario.new(name)
        scenario.controller = Thread.current[:controller]

        proxy = ScenarioProxy.new(scenario)
        proxy.instance_eval(&block) if block_given?

        Robin.registry.register(scenario.controller_name, scenario)
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
end # RobinRails
