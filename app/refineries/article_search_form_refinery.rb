#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleSearchFormRefinery < ApplicationRefinery
  def root
    false
  end

  def default
    [
      :q, :fair, :ecologic, :small_and_precious, :condition,
      :category_id, :zip, :order_by, :search_in_content
    ]
  end
end
