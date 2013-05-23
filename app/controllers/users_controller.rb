class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_user

  def profile
  end

  def show
    @articles = @user.articles.paginate(:page => params[:page] , :per_page=>12)
    if @user.id == current_user.id
      get_sales
      render :sales
      return
    end
  end

  def sales
    get_sales
  end


  #def edit
  #  @user = current_user
  #end

  private
  def get_sales
    @offers = @user.articles.paginate :page => params[:offers_page] , :per_page => 12
    @inactive = @user.articles.where(:active => false).paginate :page => params[:inactive_page] , :per_page => 12
  end

  def get_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

end