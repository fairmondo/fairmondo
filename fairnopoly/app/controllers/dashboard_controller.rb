class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  # GET /dashboard
  # GET /dashboard.json
  def index
    
    @userevents = Userevent.where(:user_id => current_user.id).paginate(:page => params[:page],:per_page => 2).order('created_at DESC') #find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC")
    
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @userevents }
      end
  end
end