class BusinessTransactionRefinery < ApplicationRefinery

  def default
    [
      :selected_transport, :selected_payment, :tos_accepted, :message,
      :quantity_bought, :forename, :surname, :street, :address_suffix, :city,
      :zip, :country, :refund_reason, :refund_explanation,
      :billed_for_fair, :billed_for_fee, :billed_for_discount
      # billed_for are booleans for checking if this transaction is already billed
    ]
  end

  def edit
    use_root
    default
  end
end
