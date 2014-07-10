class CartCheckoutForm
  attr_accessor :session, :cart, :form_objects, :checkout, :payment_address, :transport_address

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

    if cart.user.standard_address && cart.user.standard_address.valid?
      self.payment_address = cart.user.standard_address
    else
      self.payment_address = cart.user.addresses.build
    end
  end

  def session_valid?
    build_form_objects_from session[:cart_checkout]
    unless session[:cart_checkout].empty?
      return valid?
    end
    nil #for safety
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

  def needs_new_payment_address?
    self.payment_address.new_record?
  end

  def same_transport_address?
    self.transport_address == self.payment_address
  end

  private

    def build_form_objects_from params

      self.form_objects = []

      # build address if present
      create_payment_address(params) if params[:address] && needs_new_payment_address?

      assign_transport_address(params[:transport_address_id])

      self.cart.line_item_groups.each do |group|

        # builds business_transactions
        group.line_items.each do |item|
          transaction_params = params[:line_items][item.id.to_s] rescue nil
          create_business_transaction_for group, item, transaction_params
        end

        # assigns attributes to line_item_groups
        group_params = params[:line_item_groups][group.id.to_s] if params[:line_item_groups]
        group.assign_attributes(group_params.for(group).on(:update).refine) if group_params
        group.payment_address = self.payment_address
        group.transport_address = self.transport_address
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
      business_transaction.seller = group.seller
      business_transaction.article = item.article
      self.form_objects << business_transaction
    end

    def create_payment_address address_params
      self.payment_address.assign_attributes(address_params.for(Address).on(:create).refine)
      # save this to the db if validations do not fail
      saved = self.payment_address.save
      self.form_objects << self.payment_address # for form logic purposes
      # set this as the users new standard address (to discuss)
      self.cart.user.update_attribute(:standard_address_id, self.payment_address.id) if saved
    end

    def assign_transport_address address_id
      if address_id && address_id != "0"
        self.transport_address = cart.user.addresses.find address_id
      else
        self.transport_address = self.payment_address
      end
    end



end