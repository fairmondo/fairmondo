#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LibraryTest < ActiveSupport::TestCase
  subject { Library.new }

  describe 'associations' do
    should have_many(:library_elements).dependent(:destroy)
    should have_many(:articles)
    should belong_to :user
    should have_many(:hearts)
    should have_many(:comments).dependent(:destroy)
  end

  describe 'model attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :name }
    it { _(subject).must_respond_to :public }
    it { _(subject).must_respond_to :user }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :library_elements_count }
    it { _(subject).must_respond_to :hearts_count }
    it { _(subject).must_respond_to :comments_count }
  end

  describe 'validations' do
    describe 'for name' do
      should validate_presence_of(:name)
      should validate_uniqueness_of(:name).scoped_to(:user_id)
      should validate_length_of(:name).is_at_most(70)
    end

    describe 'for user' do
      should validate_presence_of(:user)
    end
  end
end
