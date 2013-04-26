class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :render_dashboard_hero

  def profile
    get_user
    if @user.legal_entity
      @user = @user.becomes(LegalEntity)
    else
      @user = @user.becomes(PrivateUser)
    end
  end

  def show
    get_user    
    @auctions = @user.auctions.paginate(:page => params[:page] , :per_page=>12)
    if @user.id == current_user.id
      get_sales
    end
  end

  def sales
    get_user
    get_sales
  end
  

  def edit
    @user = current_user
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
  
  
  

end