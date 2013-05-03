class LibrariesController < InheritedResources::Base
  respond_to :html
  actions :index, :create, :update, :destroy

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
    destroy! { user_libraries_path(@user)}
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
