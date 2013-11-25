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
require 'spec_helper'

include Warden::Test::Helpers

describe 'Exhibit' do

    before :each do
      @exhibit = FactoryGirl.create(:exhibit,:queue => :queue1 )
      @exhibit2 = FactoryGirl.create(:exhibit,:queue => :queue1 )
      @content = FactoryGirl.create(:content, :key => "heading_queue1", :body => "More")
    end

    it "should render a queued article" do
      visit root_path
      page.should have_selector '.Article--teaser'

    end

    it "should show more items if you visit the more link" do
      visit root_path
      click_link "More"
      page.should have_selector '.Article--teaser'

    end

end
