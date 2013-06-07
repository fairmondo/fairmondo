#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe Category do

  let(:category) { FactoryGirl::create(:category)}

  it "has a valid Factory" do
    category.should be_valid
  end

  describe "associations" do
    it {should have_and_belong_to_many :articles}
  end

  describe "methods" do
    it "should have the correct parent_id" do
      @anotherCategory = FactoryGirl.create(:category, :parent => category)
      @anotherCategory.parent.should eq category
    end

    it "should not have a parent_id without a parent" do
      @anotherCategory = FactoryGirl.create(:category)
      @anotherCategory.parent.should_not eq category
    end

    it "should return self_and_ancestors_ids" do
      childCategory = FactoryGirl.create(:category, parent: category)
      childCategory.self_and_ancestors_ids.should eq [childCategory.id, category.id]
    end
  end
end
