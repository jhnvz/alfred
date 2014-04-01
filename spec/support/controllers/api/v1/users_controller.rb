module Api
  module V1
    class UsersController < ActionController::Base
      respond_to :xml, :json

      def index
        @users = User.all

        respond_with(@users)
      end

    end
  end
end
