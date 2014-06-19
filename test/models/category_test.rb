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

  let(:category) { FactoryGirl::create(:category)}

  it "has a valid Factory" do
    category.valid?.must_equal true
  end

  describe "associations" do
    it {subject.must have_and_belong_to_many :articles}
  end

  describe "methods" do
    describe "#parent" do
      it "should have the correct parent_id" do
        @anotherCategory = FactoryGirl.create(:category, :parent => category)
        @anotherCategory.parent.must_equal category
      end

      it "should not have a parent_id without a parent" do
        @anotherCategory = FactoryGirl.create(:category)
        @anotherCategory.parent.wont_equal category
      end
    end

  end
end
