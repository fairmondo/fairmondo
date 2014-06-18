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
require_relative '../test_helper'

describe ContentsController do
  def login_admin
    sign_in FactoryGirl.create :admin_user
  end

  let(:content) { FactoryGirl.create :content }
  let(:content_attrs) { FactoryGirl.attributes_for :content }

  describe "GET index" do
    it "should assign all contents as @contents" do
      content
      login_admin
      get :index
      assigns(:contents).must_equal [content]
    end
  end

  describe "GET show" do
    it "should assign the requested content as @content" do
      get :show, id: content.to_param
      assigns(:content).must_equal content
      assert_template :show
    end
  end

  describe "GET new" do
    it "should assign a new content as @content" do
      login_admin
      get :new
      assert_template :new
    end
  end

  describe "GET edit" do
    it "should assign the requested content as @content" do
      login_admin
      get :edit, id: content.to_param
      assigns(:content).must_equal content
      assert_template :edit
    end
  end

  describe "POST create" do
    before { login_admin }

    describe "with valid params" do
      it "should create a new Content" do
        assert_difference 'Content.count', 1 do
          post :create, content: content_attrs
        end
      end

      it "should assign a newly created content as @content" do
        post :create, content: content_attrs
        assigns(:content).must_be_instance_of Content
        assigns(:content).persisted?.must_equal true
      end

      it "should redirect to the created content" do
        post :create, content: content_attrs
        assert_redirected_to Content.last
      end
    end

    describe "with invalid params" do
      it "should assign a newly created but unsaved content as @content" do
        # Trigger the behavior that occurs when invalid params are submitted
        Content.any_instance.stubs(:save).returns(false)
        post :create, content: { body: '' }
        assigns(:content).persisted?.must_equal false
      end
    end
  end

  describe "PUT update" do
    before { login_admin }

    context "with valid params" do
      it "should assign the requested content as @content" do
        patch :update, id: content.to_param, content: {body: 'Foobar'}
        assigns(:content).key.must_equal content.to_param
        assigns(:content).body.must_equal 'Foobar'
      end

      it "should redirect to the content" do
        patch :update, id: content.to_param, content: {body: 'Barbaz'}
        assert_redirected_to content
      end
    end
  end

  describe "DELETE destroy" do
    describe "as admin" do
      before { login_admin }

      it "should destroy the requested content" do
        content
        assert_difference 'Content.count', -1 do
          delete :destroy, id: content.to_param
        end
      end

      it "should redirect to the contents list" do
        delete :destroy, id: content.to_param
        assert_redirected_to  contents_url
      end
    end

    describe "as random user" do
      it "should not destroy the requested content" do
        content
        assert_no_difference 'Content.count' do
          delete :destroy, id: content.to_param
        end
      end
    end
  end

end
