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

module CommentsHelper
  # render all the comments
  def comments_page
    @comments_page ||= Sanitize.clean params[:comments_page]
  end

  def comments_counter(commentable)
    # Counter caches do their own SQL magic, which is why on AJAX requests they do not reflect the current state.
    # Let's do it with the Brechstange then.
    commentable.reload
    render partial: "comments/commentable_counter", locals: { commentable: commentable }
  end
end