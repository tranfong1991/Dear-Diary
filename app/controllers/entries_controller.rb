include ActionView::Helpers::TextHelper

class EntriesController < ApplicationController
    before_action :require_user, only: [:getEntry, :index, :new, :create, :edit, :update, :destroy]
    
    def getEntry
        if Entry.exists? params[:id]
            entry = Entry.find(params[:id])
            if entry.user_id == current_user.id
                render json: {'content': entry.content}
            else
                render json: {status: 404}
            end
        else
            render json: {status: 404}
        end
    end
    
    def index
        entries = Entry.where(:user_id => current_user.id)
        
        @full = Clndr.new(:diary_cal)
        @full.start_with_month = Time.now
        @full.template= Clndr::Template::SIMPLE
        entries.each do |entry|
            content = entry.content.gsub(/(?:\n\r?|\r\n?)/, '<br>')
            
            # add_event(date, name, other data)
            @full.add_event(entry.created_at, entry.id.to_s)
        end
        @full.click_event[:click]="function(target) {
            if(target.events.length){
                $('#diary-date').html(target.date._i);
                $('#edit-btn').click(function(){
                    location.href='entries/' + target.events[0].title + '/edit';
                });
                $('#diary-modal').modal('show');
                
                $.ajax('http://52.40.168.213:3000/api/entries/' + target.events[0].title, {
                    success: function(data){
                        $('#diary-content').html(data.content);
                    }
                });
            }
        }"
    end
    
    def new
        entry = Entry.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_day, current_user.id).first
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
            redirect_to '/'
        else
            @entry.errors.full_messages.each do |message|
                flash[:danger] = message
            end
            redirect_to :back
        end
    end
    
    def edit
        entries = Entry.where("id = ? AND user_id = ?", params[:id], current_user.id)
        if entries.blank?
            flash[:danger] = "No such entry!"
            redirect_to '/'
        end
        @entry = entries.first
    end
    
    def update
        entries = Entry.where("id = ? AND user_id = ?", params[:id], current_user.id)
        if entries.blank?
            flash[:danger] = "No such entry!"
            redirect_to '/'
        else
            entry = entries.first
            if entry.update_attributes(entry_params)
                flash[:success] = "Successfully updated entry!"
                redirect_to '/'
            else
                flash[:warning] = "Failed to update entry!"
                render 'edit'
            end
        end
    end
    
    def destroy
        entries = Entry.where("id = ? AND user_id = ?", params[:id], current_user.id)
        if entries.blank?
            flash[:danger] = "No such entry!"
        else
            flash[:success] = "Successfully deleted entry!"
            entries.first.destroy
        end
        redirect_to '/'
    end
    
    private
    def entry_params
        params.require(:entry).permit(:content, :created_at)
    end
end
