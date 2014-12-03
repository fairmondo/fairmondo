#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe MassUploadsController do

  # Strictly speaking not necessary since already tested in the feature tests
  describe "GET 'new'" do

    describe "for non-signed-in users" do

      it "should require login" do
        get :new
        assert_redirected_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create :legal_entity }
      before { sign_in user }

      it "should render the :new view" do
        get :new
        assert_template :new
      end
    end
  end

  describe "mass-upload creation" do
    let(:user) { FactoryGirl.create(:legal_entity, :paypal_data) }
    let(:attributes) { FactoryGirl.attributes_for(:mass_upload, :user => user) }

    before do
      sign_in user
    end

    describe 'POST ::create' do
      it "should create a mass-upload object" do
        assert_difference 'MassUpload.count', 1 do
          post :create, mass_upload: attributes
        end
        assert_redirected_to user_path(user, :anchor => 'my_mass_uploads')
        MassUpload.last.articles.count.must_equal(3)
      end
      it "should create a mass-upload object for heavy uploaders" do
        user.update_attribute(:heavy_uploader, true)
        assert_difference 'MassUpload.count', 1 do
          post :create, mass_upload: attributes
        end
        assert_redirected_to user_path(user, :anchor => 'my_mass_uploads')
        MassUpload.last.articles.count.must_equal(3)
      end
    end

    describe 'PUT ::update' do
      it "should update description" do
        post :create, mass_upload: attributes
        mass_upload = MassUpload.last
        mass_upload.finish!
        post :update, :id => MassUpload.last.id
        assert_redirected_to user_path(user)
        MassUpload.last.articles.first.active?.must_equal true
      end
    end
  end
end
