class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  # GET /dashboard
  # GET /dashboard.json
  def index
    
    @userevents = Userevent.find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC")
    
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @userevents }
      end
  end
end