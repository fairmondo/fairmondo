# This module compiles all checks (usually ending with aquestion mark) called on
# an article.
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
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

  def save_as_template?
    save_as_template == "1"
  end

  def is_template?
    # works even when the db state did not change yet
    state.to_sym == :template
  end

  def qualifies_for_discount?
    Discount.current.count > 0
  end

  def belongs_to_legal_entity?
    seller.is_a?(LegalEntity)
  end

  # Elastic
  def delete_from_index?
    !active?
  end

  # should the fair alternative be shown for the seller
  def show_fair_alternative_for_seller?
    if $exceptions_on_fairmondo['no_fair_alternative'] && $exceptions_on_fairmondo['no_fair_alternative']['user_ids']
        $exceptions_on_fairmondo['no_fair_alternative']['user_ids'].each do |user_id|
        if self.seller.id == user_id
          return false
        end
      end
    end
    true
  end

end
