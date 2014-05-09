#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
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
    @search_cache || ArticleSearchForm.new(attributes)
  end

end


