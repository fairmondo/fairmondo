#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class CommentMailerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:comment) { create(:comment) }
  let(:commentable_owner) { create(:user) }

  it '#report_comment' do
    mail = CommentMailer.report_comment(comment, commentable_owner).deliver

    assert_not ActionMailer::Base.deliveries.empty?

    mail.must have_subject(I18n.t('comment.mailer.notification_title'))
    mail.must have_body_text comment.commentable.name
    mail.must have_body_text library_url(comment.commentable)
    mail.must have_body_text commentable_owner.nickname

    mail.must deliver_to commentable_owner.email
  end
end
