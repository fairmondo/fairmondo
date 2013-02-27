class DashboardController < ApplicationController



  before_filter :authenticate_user!
  #autocomplete :user, :name, :full => true ,:display_value => :fullname , :extra_data => [:surname] , :scopes => [:search_by_name]
  def get_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @limit_userevents=5
    if params[:userevents]
      @limit_userevents=params[:userevents].to_i
    end
    if @user==current_user
      @userevents = Userevent.find(:all,:conditions => [ "user_id = ?", current_user.id], :order =>"created_at DESC", :limit => @limit_userevents)
      @limit_userevents += 10
      @ffps = @user.ffps.sum(:price,:conditions => ["activated = ?",true])
    end
  end

  def profile
    get_user
    if @user.legal_entity
      @user = @user.becomes(LegalEntity)
    else
      @user = @user.becomes(PrivateUser)
    end
  end

  def index
    get_user    
    @auctions = @user.auctions.paginate(:page => params[:page] , :per_page=>12)
    if @user == current_user
      get_sales
    end
  end

  def search_users
    get_user
    
    @users = User.paginate :page => params[:page], :per_page=>12
   

  end

  def list_followers
    get_user
    @users = @user.user_followers
  end

  def list_following
    get_user
    @users = @user.following_by_type('User')
    @auctions = @user.following_by_type('Auction').paginate(:page => params[:page] , :per_page=>12)
  end

  def collection
    get_user
    @libraries = @user.libraries
    
  end
  
  def new_library
    name = t('collection.standard')
    if params[:library_name]
     name = params[:library_name]
    end
    if !Library.exists? current_user.libraries.where(:name => name).first
      Library.create(:name => name,:public => false, :user_id => current_user.id)
    else
      flash[:error] = t('collection.exist')
    end
    respond_to do |format|
      @library = Library.find_by_name(name)
      if @library
        id = @library.id.to_s
      else
        flash[:error] = t('collection.error')  
        id = ""
      end
      
      format.html { redirect_to url_for :controller => "dashboard", :action => "collection" ,:anchor => "collection_"+id}
      format.json { head :no_content }
    end
  end
  
  def set_library_public
    if params[:id]
      Library.update(params["id"], :public => true)
      @library = Library.find(params[:id])
      id = @library ? @library.id.to_s : ""
      respond_to do |format|
        format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+id}
        format.json { head :no_content }
      end
    end
  end
  
  def set_library_private
    if params[:id]
      Library.update(params["id"], :public => false)
      @library = Library.find(params[:id])
      id = @library ? @library.id.to_s : ""
      respond_to do |format|
        format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+id}
        format.json { head :no_content }
      end
    end
  end
  
  def add_to_library
    name = t('collection.standard')
    if params[:id] && params[:library_id]
      name = params[:library_name]
      @library = Library.find(params[:library_id])
      @library_element = LibraryElement.find(params[:id])
      if @library_element.update_attributes( :library_id => params[:library_id])
        respond_to do |format|
          format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+@library_element.library_id.to_s}
          format.json { head :no_content }
        end
      else
        # if the lib_element is already in the library
        flash[:error] = t('collection.already_in_collection')
        respond_to do |format|
          format.html { redirect_to (url_for :controller => "dashboard", :action => "collection" ,:anchor => "collection_"+@library_element.library_id.to_s),:flash => { :error => I18n.t('auction.notices.collect_error')}}
          format.json { head :no_content }
        end
      end
    end
  end
  
  def delete_library_element
    library_element = LibraryElement.find(params[:id])
    library =library_element.library
    if params[:id]
      LibraryElement.delete(params[:id])
    end
    respond_to do |format|
      format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+library.id.to_s}
      format.json { head :no_content }
    end
  end

  def community

      get_user
      @invitor = @user.invitor
      @users = User.where(:invitor_id => @user.id)
      @invitor_image = @invitor.image unless @invitor == nil 
     
   
    
    #@invited_people = User.where(:invitor_id => current_user.id)

  end

  # Interact with user model

  def follow
    @user = User.find params["id"]
    current_user.follow(@user)
    Userevent.new(:user => current_user, :event_type => UsereventType::USER_FOLLOW, :appended_object => @user).save

    respond_to do |format|
      format.html { redirect_to dashboard_path(:id => @user.id) , :notice => (I18n.t 'user.follow.following') }
      format.json { head :no_content }
    end
  end
  
  def stop_follow
    
    @user = User.find params["id"]
    current_user.stop_following(@user) # Deletes that record in the Follow table
    
    respond_to do |format|
      format.html { redirect_to dashboard_path(:id => @user.id) , :notice => (I18n.t 'user.follow.stop_following') }
      format.json { head :no_content }
    end

  end
  
  def sales
    get_user
    get_sales
    
  end
  
  def get_sales
        
    @offers = @user.auctions
    @sold = @user.auctions
    @auction_templates = @user.auction_templates
  end

  def edit_profile
    @user = current_user
  end

end