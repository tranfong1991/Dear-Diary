class EntriesController < ApplicationController
    before_action :require_user, only: [:index, :show, :new, :create]
    
    def index
        # current_user_id = session[:user_id]
        # entries = Entry.where(:user_id => current_user_id)
        
        @simple_calendar = Clndr.new(:simple)
        @simple_calendar.template= Clndr::Template::SIMPLE
    end
    
    def new
        @entry = Entry.new
    end
    
    def show
        @entry = Entry.find(params[:id])
    end
    
    def create
        current_user_id = session[:user_id]
        @entry = Entry.new(entry_params)
        @entry.user_id = current_user_id
        if @entry.save
            flash[:success] = "Entry successfully saved."
        else
            flash[:danger] = "Failed to save entry. Please try again."
        end
        redirect_to '/'
    end
    
    private
    def entry_params
        params.require(:entry).permit(:content)
    end
end
