#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    if receives_notifications?(comment.commentable_user)
      CommentMailer.report_comment(comment, comment.commentable_user).deliver_later
    end
  end

  private

  def receives_notifications?(user)
    user.receive_comments_notification
  end
end
