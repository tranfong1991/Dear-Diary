include ActionView::Helpers::TextHelper

class EntriesController < ApplicationController
    before_action :require_user, only: [:index, :new, :create]
    
    def index
        entries = Entry.where(:user_id => current_user.id)
        
        @full = Clndr.new(:diary_cal)
        @full.start_with_month = Time.now
        @full.template= Clndr::Template::SIMPLE
        entries.each do |entry|
            content = entry.content.gsub(/(?:\n\r?|\r\n?)/, '<br>')
            @full.add_event(entry.created_at, entry.id.to_s, description: content)
        end
        @full.click_event[:click]="function(target) {
            if(target.events.length){
                $('#diary-date').html(target.date._i);
                $('#diary-content').html(target.events[0].description);
                $('#edit-btn').click(function(){
                    location.href='entries/' + target.events[0].title + '/edit';
                });
                $('#diary-modal').modal('show');
            }
        }"
    end
    
    def new
        entry = Entry.where("created_at >= ?", Time.zone.now.beginning_of_day).first
        if entry.nil?
            @entry = current_user.entries.new
        else
            flash[:warning] = "You already wrote one today. Please edit the existing one."
            redirect_to '/'
        end
    end
    
    def create
        @entry = current_user.entries.new(entry_params)
        if @entry.save
            flash[:success] = "Entry successfully saved."
        else
            flash[:danger] = "Failed to save entry. Please try again."
        end
        redirect_to '/'
    end
    
    def edit
        @entry = Entry.find(params[:id])
    end
    
    def update
        @entry = Entry.find(params[:id])
        if @entry.update_attributes(entry_params)
            redirect_to '/'
        else
            render 'edit'
        end
    end
    
    def destroy
        @entry = Entry.find(params[:id])
        @entry.destroy
        redirect_to '/'
    end
    
    private
    def entry_params
        params.require(:entry).permit(:content)
    end
end
