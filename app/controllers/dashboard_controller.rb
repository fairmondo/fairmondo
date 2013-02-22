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
    end
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
    end
    respond_to do |format|
      format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+t('collection.standard').delete(' ')}
      format.json { head :no_content }
    end
  end
  
  def set_library_public
    if params[:id]
      Library.update(params["id"], :public => true)
      @library = Library.find(params[:id])
      respond_to do |format|
        format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+@library.name.delete(' ')}
        format.json { head :no_content }
      end
    end
  end
  
  def set_library_private
    if params[:id]
      Library.update(params["id"], :public => false)
      @library = Library.find(params[:id])
      respond_to do |format|
        format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+@library.name.delete(' ')}
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
          format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+@library.name.delete(' ')}
          format.json { head :no_content }
        end
      else
        # if the lib_element is already in the library
        respond_to do |format|
          format.html { redirect_to (url_for :controller => "dashboard", :action => "collection"),:flash => { :error => I18n.t('auction.notices.collect_error')}}
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
      format.html { redirect_to url_for :controller => "dashboard", :action => "collection", :anchor => "collection_"+library.name.delete(' ')}
      format.json { head :no_content }
    end
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
    
    @offers = @user.auctions.where("expire > ?", Time.now)
    @sold = @user.auctions.where("expire < ?", Time.now)
    @templates = @user.auction_templates
    
  end

end