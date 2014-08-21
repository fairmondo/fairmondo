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

  # comments path depending on commentable class
  def comment_path commentable, comment
    get_path "comment", commentable, comment
  end
  # comments path depending on commentable class
  def comments_path commentable
    get_path "comments", commentable
  end

  def comments_counter(commentable)
    # Counter caches do their own SQL magic, which is why on AJAX requests they do
    # not reflect the current state.
    # Let's do it with .reload then.
    commentable.reload
    render partial: "comments/commentable_counter",
           locals: { commentable: commentable }
  end

  # notice that gets displayed instead of the #new form
  def comments_replacement_notice_for commentable
    if commentable.is_a?(Article) and commentable.seller_vacationing?
      t('comments.seller_vacationing')
    elsif !current_user
      t('comments.login_to_comment', href: link_to(t('comments.login_href'), new_user_session_path)).html_safe
    end
  end

  # notice that gets displayed along with the #new form
  def comments_additional_notice_for commentable
    if commentable.is_a?(Article) and commentable.user.is_a?(LegalEntity)
      t('article.show.comments.legal_entity_publish_info')
    end
  end

  private
    def get_path specific, *attrs
      send("#{attrs.first.class.name.downcase}_#{specific}_path", *attrs)
    end
end
