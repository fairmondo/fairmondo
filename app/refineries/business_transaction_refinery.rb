class BusinessTransactionRefinery < ApplicationRefinery

  def default
    [
      :selected_transport, :selected_payment, :quantity_bought
    ]
  end

end
