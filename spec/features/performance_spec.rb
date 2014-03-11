# This is kind of a special integration test group.
#
# Since our test suite also notices performance issues via the bullet gem
# we need tests that specifically trigger n+1 issues.
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

require 'spec_helper'

include Warden::Test::Helpers
include BulletMatcher

describe 'Performance' do
  before { Bullet.start_request }

  describe "Article#index", search: true do
    before do
      2.times { FactoryGirl.create(:article, :with_fixture_image) }
      Sunspot.commit
    end

    it "should not show bullet warnings" do
      visit articles_path
      Bullet.should_not throw_warnings
    end
  end

  describe "Article#show" do
    before do
      @seller = FactoryGirl.create(:user)
      @library = FactoryGirl.create(:library, :user => @seller)
      @art1 = FactoryGirl.create(:article, :with_fixture_image, :seller => @seller)
      @art2 = FactoryGirl.create(:article, :with_fixture_image, :seller => @seller)
      FactoryGirl.create(:library_element , :article => @art1 , :library => @library)
    end
    it "should not show bullet warnings" do
      visit article_path(@art1)
      Bullet.should_not throw_warnings
    end

  end

end
