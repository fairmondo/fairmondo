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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly. If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe CommentObserver do

  let(:comment) { FactoryGirl.create(:comment) }
  subject { comment }

  describe "Comment creation" do
    it "should send an email to the commentable owner" do
      mock = MiniTest::Mock.new
      mock.expect :receive_comments_notification, true
      CommentMailer.expects(:report_comment_on_library).
        with(comment, comment.commentable.user).returns mock
      CommentObserver.instance.after_save(comment)
    end
  end
end
