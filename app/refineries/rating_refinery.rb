#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RatingRefinery < ApplicationRefinery
  def default
    [:rating, :rated_user_id, :text, :line_item_group_id]
  end
end
