class LibraryElementsController < InheritedResources::Base
  respond_to :html
  actions :create, :update, :destroy
  before_filter :get_user
  before_filter :authenticate_user!

  def create
    authorize build_resource
    create! do |success,failure|
      success.html { redirect_to auction_path(@library_element.auction), :notice => I18n.t('library_element.notice.success' , :name => @library_element.library.name) }
      failure.html { redirect_to auction_path(@library_element.auction), :alert => @library_element.errors.messages[:library_id].first}
    end
  end

  def update
    authorize resource
    update! do |success,failure|
      success.html { redirect_to user_libraries_path(@user, :anchor => "library"+@library_element.library.id.to_s)  }
      failure.html { redirect_to user_libraries_path(@user) , :alert => @library_element.errors.messages[:library_id].first}
    end
  end

  def destroy
    authorize resource
    destroy! { user_libraries_path(@user , :anchor => "library"+resource.library.id.to_s )}

  end

  protected

  def get_user
    @user = User.find params[:user_id]
  end

end
