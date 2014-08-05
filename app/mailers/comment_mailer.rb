class CommentMailer < ActionMailer::Base
  def report_comment_on_library(comment, commentable_owner)
    @commentable = comment.commentable
    @commentable_owner = commentable_owner

    mail(to: @commentable_owner.email, subject: I18n.t('comment.new_notification'))
  end
end
