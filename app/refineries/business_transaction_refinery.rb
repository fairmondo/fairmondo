class BusinessTransactionRefinery < ApplicationRefinery
  def default
    [
      :selected_transport,
      :selected_payment,
      :quantity_bought,
      :bike_courier_message,
      :bike_courier_time,
      :tos_bike_courier_accepted
    ]
  end
end
