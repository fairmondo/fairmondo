#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  subject { Comment.new }

  describe 'associations' do
    should belong_to :user
    should belong_to :commentable
  end

  describe 'model attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :commentable_id }
    it { _(subject).must_respond_to :commentable_type }
    it { _(subject).must_respond_to :user_id }
  end

  describe 'validations' do
    should validate_presence_of(:user)
    should validate_presence_of(:commentable)
    describe 'for text' do
      should validate_presence_of(:text)
      should validate_length_of(:text).is_at_most(1000)
    end
  end

  describe '#commentable_user' do
    let(:comment) { create(:comment) }

    it 'should return the owner of the commentable' do
      comment.commentable_user.must_equal(comment.commentable.user)
    end
  end
end
