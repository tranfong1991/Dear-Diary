class EntriesController < ApplicationController
    before_action :require_user, only: [:index, :show]
    
    def index
    end
    
    def new
    end
    
    def show
    end
    
    def create
    end
end
