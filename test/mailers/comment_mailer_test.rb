#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative "../test_helper"

describe CommentMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:comment) { FactoryGirl.create(:comment) }
  let(:commentable_owner) { FactoryGirl.create(:user) }

  it "#report_comment" do
    mail = CommentMailer.report_comment(comment, commentable_owner).deliver

    assert_not ActionMailer::Base.deliveries.empty?

    mail.must have_subject(I18n.t('comment.mailer.notification_title'))
    mail.must have_body_text comment.commentable.name
    mail.must have_body_text library_url(comment.commentable)
    mail.must have_body_text commentable_owner.nickname

    mail.must deliver_to commentable_owner.email
  end
end
