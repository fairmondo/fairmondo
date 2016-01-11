#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
