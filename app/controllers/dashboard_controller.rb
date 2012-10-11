class DashboardController < ApplicationController
  
   before_filter :authenticate_user!
   #autocomplete :user, :name, :full => true ,:display_value => :fullname , :extra_data => [:surname] , :scopes => [:search_by_name]
   def index
   
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    if @user==current_user 
      @userevents = Userevent.find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC", :limit => 10)
      @ffps = @user.ffps.sum(:price,:conditions => ["activated = ?",true])
    end
    @auctions = @user.auctions.paginate(:page => params[:page] , :per_page=>12)
    @image = @user.image unless @user.image.url ==  "/images/original/missing.png"

  end

  
  def search_users
     if params["q"] && !params["q"].blank?
         @users = User.with_query(params["q"]).paginate( :page => params[:page], :per_page=>12)
      else
         @users = User.paginate :page => params[:page], :per_page=>12
      end
   
  end
  
  def follow_user
   
   
    @user = User.find params["id"]
    current_user.follow(@user)
      
    respond_to do |format|
         format.html { redirect_to dashboard_path(:id => @user.id) , :notice => (I18n.t 'user.follow.following') }
         format.json { head :no_content }
    end
  end
  
  def list_followers
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @users = @user.user_followers
  end
  
  def list_following
      if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
      @users = @user.all_following
  end

  def community
    
    if params[:id]
      
      @user = User.find(params[:id])
      
      @invitor = @user.invitor
      @users = User.where(:invitor_id => @user.id)
      @image = @user.image unless @user.image.url ==  "/images/original/missing.png"
      if @invitor
        @invitor_image = @invitor.image unless @invitor.image.url ==  "/images/original/missing.png"
      else
        @invitor_image = nil
      end
    else
      
      redirect_to dashboard_path
    
    end
    #@invited_people = User.where(:invitor_id => current_user.id)

  end  
  
  def admin
    @user = current_user
    #calculate the ffp amount over all ffps
    @ffp_amount = Ffp.sum(:price)
    # calculate the persentage from 50000
    @persent = (@ffp_amount.to_f/50000.0)*100.0
    @ffps = Ffp.paginate :page => params[:page], :per_page=>24
  end
  
end