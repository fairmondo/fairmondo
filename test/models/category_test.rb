#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe Category do
  subject { Category.new }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :desc }
    it { subject.must_respond_to :parent_id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :lft }
    it { subject.must_respond_to :rgt }
    it { subject.must_respond_to :depth }
    it { subject.must_respond_to :children_count }
    it { subject.must_respond_to :weight }
  end

  let(:category) { FactoryGirl.create(:category) }

  it 'has a valid Factory' do
    category.valid?.must_equal true
  end

  describe 'associations' do
    it { subject.must have_and_belong_to_many :articles }
  end

  describe 'methods' do
    describe '#parent' do
      it 'should have the correct parent_id' do
        @another_category = FactoryGirl.create(:category, parent: category)
        @another_category.parent.must_equal category
      end

      it 'should not have a parent_id without a parent' do
        @another_category = FactoryGirl.create(:category)
        @another_category.parent.wont_equal category
      end
    end
  end
end
