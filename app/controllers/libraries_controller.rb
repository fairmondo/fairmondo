class LibrariesController < InheritedResources::Base
  respond_to :html
  actions :index, :create, :update, :destroy
  custom_actions :resource => :destroy_confirm

  before_filter :render_users_hero
  before_filter :get_user

  before_filter :authenticate_user!
  def index
    @library = @user.libraries.build
    index!
  end

  def create
    @library = Library.new(params[:library])
    @library.user = User.find(params[:user_id])
    authorize @library
    create! do |success,failure|
      success.html { redirect_to user_libraries_path(@user, :anchor => "library"+@library.id.to_s) }
      failure.html { redirect_to user_ libraries_path(@user), :alert => @library.errors.full_messages.first }
    end
  end

  def update
    @library = Library.find(params[:id])
    authorize @library
    update! do |success,failure|
      success.html { redirect_to user_libraries_path(@user, :anchor => "library"+@library.id.to_s) }
      failure.html { redirect_to user_libraries_path(@user), :alert => @library.errors.full_messages.first }
    end
  end

  def destroy
    @library = Library.find(params[:id])
    authorize @library
    if !params[:confirm]
        destroy! { user_libraries_path(@user)}
    else
        redirect_to url_for(:controller => "libraries", :action => "index") ,
          :flash => { :notice => t('library.delete_confirm', :name => @library.name) +" "+
              (view_context.link_to t('library.delete'),user_library_path(@user.id, @library.id.to_s),"data-method" => "delete")}
    end
  end

  protected

  def begin_of_association_chain
    @user
  end

  def collection
    @libraries ||= LibraryPolicy::Scope.new( current_user, @user , end_of_association_chain ).resolve
  end

  def get_user
    @user = User.find(params[:user_id])
  end

end
