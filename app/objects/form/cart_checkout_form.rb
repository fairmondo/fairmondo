class CartCheckoutForm
  attr_accessor :session, :cart, :form_objects, :checkout

  def initialize session, cart, checkout
    self.session = session
    self.cart = cart
    self.checkout = checkout # determines if we are checking out or not

    # setting the default value for the fields to true if possible
    # will be overwritten by any params or session params
    cart.line_item_groups.each do |group|
      group.unified_transport = group.transport_can_be_unified?
      group.unified_payment = group.payment_can_be_unified?
    end
  end

  def session_valid?
    build_form_objects_from session[:cart_checkout]
    unless session[:cart_checkout].empty?
      valid?
    end
  end

  def process params

    build_form_objects_from checkout ? session[:cart_checkout] : params
    return :invalid unless valid?
    unless checkout
      session[:cart_checkout] = params # save everything in session
      return :saved_in_session
    else
      return cart.buy
    end
  end

  # for formtastic
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