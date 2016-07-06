class EntriesController < ApplicationController
    before_action :require_user, only: [:index, :show, :new, :create]
    
    def index
        current_user_id = session[:user_id]
        entries = Entry.where(:user_id => current_user_id)
        
        @full = Clndr.new(:diary_cal)
        @full.start_with_month = Time.now
        @full.template= Clndr::Template::SIMPLE
        entries.each do |entry|
            @full.add_event(entry.created_at, entry.id.to_s, description: entry.content)
        end
        @full.click_event[:click]="function(target) {
            if(target.events.length){
                $('#diary-date').html(target.date._i);
                $('#diary-content').html(target.events[0].description);
                $('#diary-modal').modal('show');
            }
        }"
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
