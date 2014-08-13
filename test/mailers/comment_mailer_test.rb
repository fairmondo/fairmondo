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
require_relative "../test_helper"

describe CommentMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:comment) { FactoryGirl.create(:comment) }
  let(:commentable_owner) { FactoryGirl.create(:user) }

  it "#report_comment_on_library" do
    mail = CommentMailer.report_comment_on_library(comment, commentable_owner).deliver

    assert_not ActionMailer::Base.deliveries.empty?

    mail.must have_subject(I18n.t('comment.new_notification'))
    mail.must have_body_text comment.commentable.name
    mail.must have_body_text library_url(comment.commentable)
    mail.must have_body_text commentable_owner.forename

    mail.must deliver_to commentable_owner.email
  end
end
