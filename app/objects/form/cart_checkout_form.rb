class CartCheckoutForm
  attr_accessor :session, :cart, :form_objects, :checkout

  def initialize session, cart, checkout
    self.session = session
    self.cart = cart
    self.checkout = checkout
  end

  def session_valid?
    build_form_objects_from session[:cart_checkout]
    unless session.empty?
      valid?
    end
  end

  def process params

    build_form_objects_from checkout ? session[:cart_checkout] : params

    return :invalid unless valid?
    unless checkout
      # save everything in session
      session[:cart_checkout] = params
      return :saved_in_session
    end
    return cart.buy
  end

  def persisted?
    false
  end

  private

    def build_form_objects_from params

      self.form_objects = []

      self.cart.line_item_groups.each do |group|

        group.line_items.each do |item|
          transaction_params = params[:line_items][item.id.to_s] rescue nil
          create_business_transaction_for group, item, transaction_params
        end

        group_params = params[:line_item_groups][group.id.to_s] if params[:line_item_groups]
        group.assign_attributes(group_params.for(group).on(:update).refine) if group_params

        self.form_objects << group
      end

    end

    def valid?
      invalid_objects = form_objects.select{ |object| !object.valid? }
      invalid_objects.empty?
    end

    def create_business_transaction_for group, item, transaction_params
      business_transaction = if transaction_params
        group.business_transactions.build(transaction_params.for(BusinessTransaction).on(:create).refine)
      else
        group.business_transactions.build
      end
      item.business_transaction = business_transaction
      business_transaction.quantity_bought = item.requested_quantity
      business_transaction.buyer = self.cart.user
      business_transaction.article = item.article
      self.form_objects << business_transaction
    end



end