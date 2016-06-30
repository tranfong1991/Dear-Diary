class UsersController < ApplicationController
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            redirect_to '/'
        else
            redirect_to '/signup'
        end
    end
    
    private
    def user_params
        #params is a built-in variable that holds all parameters from the url
        params.require(:user).permit(:first_name, :last_name, :user_name, :password)
    end
end