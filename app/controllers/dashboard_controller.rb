class DashboardController < ApplicationController

  before_filter :authenticate_user!
  #autocomplete :user, :name, :full => true ,:display_value => :fullname , :extra_data => [:surname] , :scopes => [:search_by_name]
  def get_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    if @user==current_user
      @userevents = Userevent.find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC", :limit => 10)
      @ffps = @user.ffps.sum(:price,:conditions => ["activated = ?",true])
    end
    @image = @user.image unless @user.image.url ==  "/images/original/missing.png"

  end

  def index
    get_user
    @auctions = @user.auctions.paginate(:page => params[:page] , :per_page=>12)

  end

  def search_users
    get_user
    if params["q"] && !params["q"].blank?
      @users = User.with_query(params["q"]).paginate( :page => params[:page], :per_page=>12)
    else
      @users = User.paginate :page => params[:page], :per_page=>12
    end

  end

  def list_followers
    get_user
    @users = @user.user_followers
  end

  def list_following
    get_user
    @users = @user.all_following
  end

  def community

      get_user
      @invitor = @user.invitor
      @users = User.where(:invitor_id => @user.id)
    
      if @invitor
        @invitor_image = @invitor.image unless @invitor.image.url ==  "/images/original/missing.png"
      else
        @invitor_image = nil
      end
   
    
    #@invited_people = User.where(:invitor_id => current_user.id)

  end

  # Interact with user model

  def follow_user
    @user = User.find params["id"]
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_to dashboard_path(:id => @user.id) , :notice => (I18n.t 'user.follow.following') }
      format.json { head :no_content }
    end
  end

end