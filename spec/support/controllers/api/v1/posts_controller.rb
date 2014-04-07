module Api
  module V1
    class PostsController < ActionController::Base
      respond_to :xml, :json

      def index
        @posts = Post.all

        respond_with(@posts)
      end

    end
  end
end
