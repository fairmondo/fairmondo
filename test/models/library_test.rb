#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class LibraryTest < ActiveSupport::TestCase
  subject { Library.new }

  describe 'associations' do
    it { subject.must have_many(:library_elements).dependent(:destroy) }
    it { subject.must have_many(:articles) }
    it { subject.must belong_to :user }
    it { subject.must have_many(:hearts) }
    it { subject.must have_many(:comments).dependent(:destroy) }
  end

  describe 'model attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :public }
    it { subject.must_respond_to :user }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :library_elements_count }
    it { subject.must_respond_to :hearts_count }
    it { subject.must_respond_to :comments_count }
  end

  describe 'validations' do
    describe 'for name' do
      it { subject.must validate_presence_of(:name) }
      it { subject.must validate_uniqueness_of(:name).scoped_to(:user_id) }
      it { subject.must ensure_length_of(:name).is_at_most(70) }
    end

    describe 'for user' do
      it { subject.must validate_presence_of(:user) }
    end
  end
end
