class UsersController < ApplicationController
    before_action :require_user, only: [:update, :settings, :destroy]
    
    def new
        @user = User.new
    end
    
    def profile
        @user = current_user
    end
    
    def account
        @user = current_user
    end
    
    def update_account
        if current_user.update_password(update_user_params)
            flash[:success] = "Password successfully updated."
            redirect_to '/'
        else
            current_user.errors.full_messages.each do |message|
                flash[:danger] = message
            end
            redirect_to :back
        end
    end
    
    def update_profile
        if current_user.update_attributes(update_user_params)
            flash[:success] = "Profile successfully updated."
        else
            current_user.errors.full_messages.each do |message|
                flash[:danger] = message
            end
        end
        redirect_to :back
    end
    
    def create
        if not unique_username?
            flash[:warning] = "Username already exists. Please choose another one."
            redirect_to '/signup'
        else
            @user = User.new(user_params)
            if @user.save
                flash[:success] = "Account successfully created."
                session[:user_id] = @user.id
                redirect_to '/'
            else
                @user.errors.full_messages.each do |message|
                    flash[:danger] = message
                end
                redirect_to '/signup'
            end
        end
    end
    
    def destroy
        user = User.find(params[:id])
        user.destroy
        
        session[:user_id] = nil
        flash[:success] = "Account successfully deleted."
        redirect_to '/'
    end
    
    private
    def unique_username?
        user = User.find_by_user_name(params[:user][:user_name])
        if user.nil?
          return true
        end
        return false
    end
    
    def update_user_params
        params.require(:user).permit(:first_name, :last_name, :old_password, :password, :password_confirmation)
    end
    
    def user_params
        #params is a built-in variable that holds all parameters from the url
        params.require(:user).permit(:first_name, :last_name, :user_name, :password, :password_confirmation)
    end
end
