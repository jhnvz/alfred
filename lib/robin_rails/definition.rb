module RobinRails
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
    # Robin.define do
    #   robin 'update post by manager' do
    #     setup do
    #       User.create(:name => 'John Doe', :permissions => { :manager => true })
    #       Post.create(:title => 'Robin is awesome', :body => 'It saves me time')
    #     end
    #
    #     get 'api/v1/posts#update', :id => 1
    #   end
    # end
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
      def robin(name, &block)
        robin = Robin.new(name)
        proxy = RobinProxy.new(robin)
        proxy.instance_eval(&block) if block_given?

        RobinRails.registry.register(robin.identifier, robin)
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
      # new.run do
      #   setup do
      #     User.create(:name => 'John Doe')
      #   end
      # end
      #
      # => Will call the setup method with a new block
      #
      def self.run(block)
        new.instance_eval(&block)
      end

    end # DSL

  end # Definition
end # RobinRails
