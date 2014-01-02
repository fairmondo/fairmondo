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

describe Image do

  it "has a valid Factory" do
    FactoryGirl.create(:image).should be_valid
  end

  describe "associations" do
    it { should belong_to :imageable }
  end

  describe "methods" do
    describe "::reprocess" do

      it "should call reprocess on image Object" do
        Image.stub_chain(:find,:image,:reprocess!) # for coverage / flush_errors with should_receive
        Image.reprocess 1
      end
    end
  end

end
