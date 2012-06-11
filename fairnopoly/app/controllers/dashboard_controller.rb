class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  # GET /dashboard
  # GET /dashboard.json
  def index
     
    @invitations = Invitation.all

     
    @userevents = Userevent.where(:user_id => current_user.id).paginate(:page => params[:page],:per_page => 10).order('created_at DESC') #find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC")    
    @userevents2 = Userevent.find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC")
      
    count = 0
    @links = Array.new
    @userevents2.each do |userevent|
      if count == 0 then  
        @links[count] = userevent.created_at
        count += 1
      elsif @links[count-1].strftime("%B") != userevent.created_at.strftime("%B") then
          @links[count] = userevent.created_at
          count += 1
      end
    end
    
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @userevents }
      end
  end
  
end