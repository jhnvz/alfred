module Api
  module V1
    class UsersController < ActionController::Base

      def index
        render :json => User.all.to_json
      end

    end
  end
end
