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
require 'test_helper'

describe ArticleObserver do

  let(:article) { FactoryGirl.create(:article) }
  subject { article }

  describe "Category Proposals" do
    it "should send an email when a category_proposal was given" do
      article.category_proposal = 'foo'
      mock = MiniTest::Mock.new
      mock.expect :deliver, true
      ArticleMailer.expects(:category_proposal).with('foo').returns mock
      ArticleObserver.instance.after_save article
    end
  end
end
