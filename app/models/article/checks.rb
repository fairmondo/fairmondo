# This module compiles all checks (usually ending with aquestion mark) called on an article.
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
module Article::Checks
  extend ActiveSupport::Concern

  # Does this article belong to user X?
  # @api public
  # param user [User] usually current_user
  def owned_by? user
    user && self.seller.id == user.id
  end

  def is_conventional?
    self.condition == "new" && !self.fair && !self.small_and_precious && !self.ecologic
  end

  # should the fair alternative be shown for the seller
  def show_fair_alternative_for_seller
    if $exceptions_on_fairnopoly['no_fair_alternative'] && $exceptions_on_fairnopoly['no_fair_alternative']['user_ids']
        $exceptions_on_fairnopoly['no_fair_alternative']['user_ids'].each do |user_id|
        if self.seller.id == user_id
          return false
        end
      end
    end
    true
  end

  def is_available?
    !self.sold? && self.quantity_available > 0
  end

  #only generate friendly slug if we dont have a template
  def should_generate_new_friendly_id?
    !template?
  end
end
