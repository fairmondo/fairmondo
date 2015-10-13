#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RatingPolicy < Struct.new(:user, :rating)
  def new?
    is_buyer? && has_not_rated_this? && is_not_seller?
  end

  def create?
    new?
  end

  private

  def has_not_rated_this?
    (user.given_ratings.select { |r| r.line_item_group == rating.line_item_group }).empty?
  end

  def is_buyer?
    user.is? rating.line_item_group.buyer
  end

  def is_not_seller?
    rating.line_item_group.seller != user
  end
end
