#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class HeartTest < ActiveSupport::TestCase
  subject { Heart.new }

  describe 'model attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :heartable_id }
    it { _(subject).must_respond_to :heartable_type }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :user_token }
  end

  describe 'associations' do
    should belong_to :heartable
    should belong_to :user
  end

  let(:heart) { Heart.new }
  let(:user) { create(:user) }
  let(:heartable) { create(:library) }

  describe 'validations' do
    should validate_presence_of(:user)
    should validate_presence_of(:heartable)
  end

  describe 'database uniqueness index' do
    let(:second_heart) { Heart.new(user: user, heartable: heartable) }

    before do
      heart.user = user
      heart.heartable = heartable
    end

    it 'saves a Heart with user and heartable' do
      assert heart.save
    end

    it 'barfs when trying to save a second heart' do
      heart.save
      assert_raises(ActiveRecord::RecordInvalid) { second_heart.save! }
    end
  end
end
