#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module CommentsHelper
  # render all the comments
  def comments_page
    @comments_page ||= Sanitize.clean params[:comments_page]
  end

  # comments path depending on commentable class
  def comment_path commentable, comment
    get_path 'comment', commentable, comment
  end
  # comments path depending on commentable class
  def comments_path commentable
    get_path 'comments', commentable
  end

  def comments_counter(commentable)
    render partial: 'comments/commentable_counter',
           locals: { commentable: commentable }
  end

  # notice that gets displayed instead of the #new form
  def comments_replacement_notice_for commentable
    if commentable.is_a?(Article) && commentable.seller_vacationing?
      t('comments.seller_vacationing')
    elsif !current_user
      t('comments.login_to_comment', href: link_to(t('comments.login_href'), new_user_session_path)).html_safe
    end
  end

  # notice that gets displayed along with the #new form
  def comments_additional_notice_for commentable
    if commentable.is_a?(Article) && commentable.user.is_a?(LegalEntity)
      t('article.show.comments.legal_entity_publish_info')
    end
  end

  private

  def get_path specific, *attrs
    send("#{attrs.first.class.name.downcase}_#{specific}_path", *attrs)
  end
end
