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
#

module HeartButtonHelper
  # Wraps the layout call and sanitizes the options
  #
  # param heartable_resource: the resource that the user should be able to heart.
  # @return [String] The compiled HTML of the button element
  def heart_button(heartable_resource)
    if user_signed_in?
      heart = Heart.where(heartable: heartable_resource, user: current_user)
    else
      heart = []
    end

    if heart.any?
      render partial: "hearts/heart_button", locals: {
        heartable_resource: heartable_resource,
        icon: "fa-minus",
        path: library_heart_path(heartable_resource, heart.first),
        method: :delete
      }
    else
      render partial: "hearts/heart_button", locals: {
        heartable_resource: heartable_resource,
        icon: "fa-plus",
        path: library_hearts_path(heartable_resource),
        method: :post
      }
    end
  end
end