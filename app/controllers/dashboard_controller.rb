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
    end
    
    @image = @user.image unless @user.image.url ==  "/images/original/missing.png"
    @ffps = @user.ffps.sum(:price)
    #@invitations = Invitation.all

  end
  
  #def show
  #   @user = User.find(params[:id])
  #   @image = @user.image unless @user.image.url ==  "/images/original/missing.png"
  #   @ffps = @user.ffps.sum(:price)
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render :json => @user }
  #  end
  #end

  def create
    super
  end

  def new
    super
  end

    # GET /ffps/1/edit
  def edit
    @ffp = User.find(params[:id])
  end
  
   def update
    @user = User.find(params[:id])

      respond_to do |format|
        if @user.update_attributes(params[:user])
       
        format.html { redirect_to dashboard_path, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def search_users
   
     if params["q"] && !params["q"].blank?
         @users = User.with_query(params["q"]).paginate( :page => params[:page], :per_page=>12)
      else
         @users = User.paginate :page => params[:page], :per_page=>12
      end
   
  end
    
  def trade
    
  end
    
  def timeline
    
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
  
  def community
    @invited_people = User.where(:invitor_id => current_user.id)
    @invitor = current_user.invitor
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