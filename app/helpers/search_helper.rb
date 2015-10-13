#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module SearchHelper
  # needed for the tire objects to work
  def humanize_money_or_cents money_or_cents
    money_or_cents = Money.new(money_or_cents) unless money_or_cents.is_a?(Money)
    humanized_money_with_symbol money_or_cents
  end

  def search_cache
    attributes = {}

    # attaches the category_id if we are in the categories controller
    attributes[:category_id] = params[:id] if controller_name == 'categories'

    # build fresh search cache
    @search_cache || ::ArticleSearchForm.new(attributes)
  end
end
