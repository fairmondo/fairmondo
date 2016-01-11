#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe Comment do
  subject { Comment.new }

  describe 'associations' do
    it { subject.must belong_to :user }
    it { subject.must belong_to :commentable }
  end

  describe 'model attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :commentable_id }
    it { subject.must_respond_to :commentable_type }
    it { subject.must_respond_to :user_id }
  end

  describe 'validations' do
    it { subject.must validate_presence_of(:user) }
    it { subject.must validate_presence_of(:commentable) }
    describe 'for text' do
      it { subject.must validate_presence_of(:text) }
      it { subject.must ensure_length_of(:text).is_at_most(1000) }
    end
  end

  describe '#commentable_user' do
    let(:comment) { FactoryGirl.create(:comment) }

    it 'should return the owner of the commentable' do
      comment.commentable_user.must_equal(comment.commentable.user)
    end
  end
end
