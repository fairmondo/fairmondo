class DashboardController < ApplicationController

  before_filter :authenticate_user!

  def profile
    get_user
    if @user.legal_entity
      @user = @user.becomes(LegalEntity)
    else
      redirect_to dashboard_path
    end
  end

  def index
    get_user    
    @auctions = @user.auctions.paginate(:page => params[:page] , :per_page=>12)
    if @user.id == current_user.id
      get_sales
    end
  end

  def libraries
    get_user
    @libraries = @user.libraries
    
  end
  
  def new_library
    name = t('library.default')
    if params[:library_name]
     name = params[:library_name]
    end
    if !Library.exists? current_user.libraries.where(:name => name).first
      Library.create(:name => name,:public => false, :user_id => current_user.id)
    else
      flash[:error] = t('library.exist')
    end
    respond_to do |format|
      @library = Library.find_by_name(name)
      if @library
        id = @library.id.to_s
      else
        flash[:error] = t('library.error')  
        id = ""
      end
      
      format.html { redirect_to url_for :controller => "dashboard", :action => "libraries" ,:anchor => "library_"+id}
      format.json { head :no_content }
    end
  end
  
  def set_library_public
    if params[:id]
      Library.update(params["id"], :public => true)
      @library = Library.find(params[:id])
      id = @library ? @library.id.to_s : ""
      respond_to do |format|
        format.html { redirect_to url_for :controller => "dashboard", :action => "libraries", :anchor => "library_"+id}
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
        format.html { redirect_to url_for :controller => "dashboard", :action => "libraries", :anchor => "library_"+id}
        format.json { head :no_content }
      end
    end
  end
  
  def add_to_library
  
    if params[:id] && params[:library_id]
      @library = Library.find(params[:library_id])
      @library_element = LibraryElement.find(params[:id])
      old_lib = @library_element.library
      if @library_element.update_attributes( :library_id => params[:library_id])
        respond_to do |format|
          format.html { redirect_to url_for :controller => "dashboard", :action => "libraries", :anchor => "library_"+old_lib.id.to_s}
          format.json { head :no_content }
        end
      else
        # if the lib_element is already in the library
        flash[:error] = t('library.already_in_library')
        respond_to do |format|
          format.html { redirect_to url_for(:controller => "dashboard", :action => "libraries" ,:anchor => ("library_"+old_lib.id.to_s)),:flash => { :error => I18n.t('auction.notices.collect_error')}}
          format.json { head :no_content }
        end
      end
    end
  end
  
  def delete_library_element
    library_element = LibraryElement.find(params[:id])
    if params[:id]
      LibraryElement.delete(params[:id])
    end
    respond_to do |format|
      format.html { redirect_to url_for :controller => "dashboard", :action => "libraries", :anchor => "library_"+library.id.to_s}
      format.json { head :no_content }
    end
  end
  
 def delete_library_flash
    if params[:id]
      library = Library.find(params[:id])
      if library && library.user == current_user
        respond_to do |format|
          format.html { redirect_to url_for(:controller => "dashboard", :action => "libraries") ,
            :flash => { :notice => t('library.flash.delete_confirm', :name => library.name) +" "+ 
              (view_context.link_to t('library.action.delete'), :controller => "dashboard", :action => "delete_library", :id => params[:id] )}
            }
          format.json { head :no_content }
        end
      end
    end
 end
    
  def delete_library
    if params[:id]
      library = Library.find(params[:id])
      if library && library.user == current_user  
        Library.delete(params[:id])
      end
    end
    respond_to do |format|
      format.html { redirect_to url_for :controller => "dashboard", :action => "libraries"}
      format.json { head :no_content }
    end
  end
  
  def rename_library
    if params[:library_name] && params[:id]
      library = Library.find(params[:id])
      if library && library.user == current_user  
        if !library.update_attributes( :name => params[:library_name])
        #TODO: some error message
        end
      end
    end
       
    respond_to do |format|
      format.html { redirect_to url_for(:controller => "dashboard", :action => "libraries", :anchor => "library_"+library.id.to_s)}
      format.json { head :no_content }
    end
  end

  def sales
    get_user
    get_sales
  end
  
  
  private
  def get_sales
    @offers = @user.auctions.paginate :page => params[:offers_page] , :per_page => 12
    @inactive = @user.auctions.where(:active => false).paginate :page => params[:inactive_page] , :per_page => 12
    @auction_templates = @user.auction_templates
  end
  
  def get_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
   # def community
 #     get_user
 #     @invitor = @user.invitor
 #     @users = User.where(:invitor_id => @user.id)
 #     @invitor_image = @invitor.image unless @invitor == nil   
    #@invited_people = User.where(:invitor_id => current_user.id)

 # end

  # Interact with user model

   # def search_users
   #   get_user
   #   @users = User.paginate :page => params[:page], :per_page=>12
   # end
  
 
  

end