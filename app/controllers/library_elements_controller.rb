class LibraryElementsController < InheritedResources::Base
  respond_to :html
  actions :create, :update, :destroy
  before_filter :get_user
  before_filter :authenticate_user!
  
  def create
    @library_element = LibraryElement.new(params[:library_element])
    authorize @library_element
    create! do |success,failure|
      success.html { redirect_to auction_path(@library_element.auction), :notice => I18n.t('library_element.notice.success' , :name => @library_element.library.name) }
      failure.html { redirect_to auction_path(@library_element.auction), :alert => @library_element.errors.messages[:library_id].first}
    end
  end

  
  def get_user
    @user = User.find params[:user_id]
  end
  
end
