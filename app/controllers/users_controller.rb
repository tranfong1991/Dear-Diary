class UsersController < ApplicationController
    def new
        @user = User.new
    end
    
    def create
        if not unique_username?
            flash[:warning] = "Username already exists. Please choose another one."
            redirect_to '/signup'
        else
            @user = User.new(user_params)
            if @user.save
                flash[:success] = "New account created."
                session[:user_id] = @user.id
                redirect_to '/'
            else
                flash[:danger] = "Failed to create account. Please try again."
                redirect_to '/signup'
            end
        end
    end
    
    private
    def unique_username?
        user = User.find_by_user_name(params[:user][:user_name])
        if user.nil?
          return true
        end
        return false
    end
    
    def user_params
        #params is a built-in variable that holds all parameters from the url
        params.require(:user).permit(:first_name, :last_name, :user_name, :password)
    end
end
