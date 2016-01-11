#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LineItemRefinery < ApplicationRefinery
  def create
    [:article_id, :requested_quantity]
  end

  def update
    [:requested_quantity]
  end
end
