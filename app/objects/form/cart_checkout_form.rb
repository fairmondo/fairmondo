class CartCheckoutForm
  attr_accessor :session, :cart

  def initialize session, cart
    self.session = session
    self.cart = cart
  end

  def complete?
    fill_data session, cart
    false
  end

  def process params
    fill_data params, cart
  end

  def persisted?
    false
  end

  private

    def fill_data_and

    def fill_data hash, cart
      # the data always comes in like this:
      # {  line_item_groups:
      #       { id: { unified_payment: value, ... } },
      #    line_items:
      #      { id: { business_transaction: { selected_trasport: value, ... } } } }
      #
      cart.line_item_groups.each do |group|
        group_params = hash[:line_item_groups][group.id.to_s] if hash[:line_item_groups]
        group.assign_attributes(group_params.for(group).on(:update).refine) if group_params

        group.line_items.each do |item|
          transaction_params = hash[:line_items][item.id.to_s] if hash[:line_items] && hash[:line_items][item.id.to_s]
          item.business_transaction.assign_attributes(transaction_params.for(item.business_transaction).on(:update).refine) if transaction_params
        end

      end

    end

end