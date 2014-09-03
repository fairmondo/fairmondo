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
class RatingPolicy < Struct.new(:user, :rating)

  def new?
    is_buyer? && has_not_rated_this? && is_not_seller?
  end

  def create?
    new?
  end

  private
    def has_not_rated_this?
      (user.given_ratings.select {|r| r.line_item_group == rating.line_item_group } ).empty?
    end

    def is_buyer?
      user.is? rating.line_item_group.buyer
    end

    def is_not_seller?
      rating.line_item_group.seller != user
    end

end
