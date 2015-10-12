#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# This module compiles all checks (usually ending with aquestion mark) called on
# an article.

module Article::Checks
  extend ActiveSupport::Concern

  # Does this article belong to user X?
  # @api public
  # param user [User] usually current_user
  def owned_by? user
    user && self.seller.id == user.id
  end

  def is_conventional?
    condition == 'new' && !fair && !small_and_precious && !ecologic
  end

  def save_as_template?
    save_as_template == '1'
  end

  def should_get_a_slug?
    !closed? && !is_template?
  end

  def is_template?
    # works even when the db state did not change yet
    self.state.to_sym == :template
  end

  def qualifies_for_discount?
    Discount.current.count > 0
  end

  def belongs_to_legal_entity?
    seller.is_a?(LegalEntity)
  end

  def bought_or_in_cart?
    self.business_transactions.any? || self.line_items.any?
  end

  # should the fair alternative be shown for the seller
  def show_fair_alternative_for_seller?
    if EXCEPTIONS_ON_FAIRMONDO['no_fair_alternative'] && EXCEPTIONS_ON_FAIRMONDO['no_fair_alternative']['user_ids']
      EXCEPTIONS_ON_FAIRMONDO['no_fair_alternative']['user_ids'].each do |user_id|
        if self.seller.id == user_id
          return false
        end
      end
    end
    true
  end
end
