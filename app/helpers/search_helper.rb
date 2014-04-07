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

  extend Memoist

  def humanize_money_or_cents money_or_cents
    money_or_cents = Money.new(money_or_cents) unless money_or_cents.is_a?(Money)
    humanized_money_with_symbol money_or_cents
  end


  # returns a merged object
  def search_params_merged_with object
    object.merge! :category_id => params[:id] if params[:controller] == 'categories'
    (params[:article_search_form] || {}).merge object
  end

  memoize :search_params_merged_with

end


