#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaymentRefinery < ApplicationRefinery
  def default
    [:type, :pay_key, :line_item_group_id]
  end
end
