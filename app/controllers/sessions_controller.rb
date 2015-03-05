# https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb
class SessionsController < Devise::SessionsController

  skip_before_filter :check_new_terms
  after_filter :save_belboon_tracking_token_in_user, only: :create
  before_filter :clear_void_belboon_tracking_token_from_user, only: :destroy

  def create
    super

    if cart = Cart.find_by_id(cookies.signed[:cart])
      cart.update_attribute :user_id, current_user.id unless cart.user_id
    else # user probably doesn't have cart cookie set
      @current_cart = Cart.current_for current_user
      cookies.signed[:cart] = @current_cart.id if @current_cart
    end
  end

  def destroy
    super

    cookies.delete :cart
  end
end
