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

describe ArticleTemplate do
  let(:article_template) { FactoryGirl.create(:article_template) }
  subject { article_template }

  it "should have a valid factory" do
    should be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of(:name).scoped_to(:user_id)}
  it {should validate_presence_of :user_id}

  it {should belong_to :user}
  it {should have_one(:article).dependent(:destroy)}
  it {should accept_nested_attributes_for :article}

  describe "articles_article_template validation" do
    before do
      article_template = FactoryGirl.build(:article_template)
    end

  end

end
