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

describe HeartsController do

  describe "POST Heart on libraries" do
    describe "for non-signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library)
        @library_2 = FactoryGirl.create(:library)
      end

      it "should allow posting" do
        post :create, library_id: @library.id
        puts response.header
        assert_response :success
      end

      it 'should not allow posting twice to the same library' do
        post :create, library_id: @library.id
        post :create, library_id: @library.id
        assert_response :failure
      end

      it 'should allow posting to another library' do
        post :create, library_id: @second_library.id
        assert_response :success
      end
    end
  end
end