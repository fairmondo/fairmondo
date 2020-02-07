#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  subject { Feedback.new }

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :from }
    it { _(subject).must_respond_to :subject }
    it { _(subject).must_respond_to :text }
    it { _(subject).must_respond_to :to }
    it { _(subject).must_respond_to :variety }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :article_id }
    it { _(subject).must_respond_to :feedback_subject }
    it { _(subject).must_respond_to :help_subject }
    it { _(subject).must_respond_to :source_page }
    it { _(subject).must_respond_to :user_agent }
    it { _(subject).must_respond_to :forename }
    it { _(subject).must_respond_to :lastname }
    it { _(subject).must_respond_to :organisation }
    it { _(subject).must_respond_to :phone }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
  end

  describe 'associations' do
    should belong_to :user
    should belong_to :article
  end

  describe 'validations' do
    should validate_presence_of(:text)
    should validate_presence_of :variety
    should_not allow_value('test@').for :from
    should_not allow_value('@test.').for :from
    should_not allow_value('test.com').for :from
    should allow_value('test@test.museum').for :from
    should allow_value('test@test.co.uk').for :from 

    describe 'when validating send_feedback' do
      before { subject.variety = 'send_feedback' }
      should validate_presence_of :feedback_subject
      should validate_presence_of :subject
    end

    describe 'when validating get_help' do
      before { subject.variety = 'get_help' }
      should validate_presence_of :help_subject
      should validate_presence_of :subject
    end
  end

  describe 'methods' do
    describe '#put_user_id(current_user)' do
      it 'should set the user_id when signed a user is given' do
        user = create :user
        f = Feedback.new
        f.put_user_id user
        f.user_id.must_equal user.id
      end

      it 'should not set the user_id when signed out' do
        f = Feedback.new
        f.put_user_id nil
        assert_nil f.user_id
      end
    end
  end
end
