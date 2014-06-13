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
require 'test_helper'

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
      assigns(:contents).should eq [content]
    end
  end

  describe "GET show" do
    it "should assign the requested content as @content" do
      get :show, id: content.to_param
      assigns(:content).should eq content
    end
  end

  describe "GET new" do
    it "should assign a new content as @content" do
      login_admin
      get :new
      assigns(:content).should be_a_new Content
    end
  end

  describe "GET edit" do
    it "should assign the requested content as @content" do
      login_admin
      get :edit, id: content.to_param
      assigns(:content).should eq content
    end
  end

  describe "POST create" do
    before { login_admin }

    describe "with valid params" do
      it "should create a new Content" do
        expect {
          post :create, content: content_attrs
        }.to change(Content, :count).by 1
      end

      it "should assign a newly created content as @content" do
        post :create, content: content_attrs
        assigns(:content).should be_a Content
        assigns(:content).should be_persisted
      end

      it "should redirect to the created content" do
        post :create, content: content_attrs
        response.should redirect_to Content.last
      end
    end

    describe "with invalid params" do
      it "should assign a newly created but unsaved content as @content" do
        # Trigger the behavior that occurs when invalid params are submitted
        Content.any_instance.stub(:save).and_return(false)
        post :create, content: { body: '' }
        assigns(:content).should be_a_new Content
      end
    end
  end

  describe "PUT update" do
    before { login_admin }

    context "with valid params" do
      it "should assign the requested content as @content" do
        patch :update, id: content.to_param, content: {body: 'Foobar'}
        assigns(:content).key.should eq content.to_param
        assigns(:content).body.should eq 'Foobar'
      end

      it "should redirect to the content" do
        patch :update, id: content.to_param, content: {body: 'Barbaz'}
        response.should redirect_to content
      end
    end
  end

  describe "DELETE destroy" do
    context "as admin" do
      before { login_admin }

      it "should destroy the requested content" do
        content
        expect {
          delete :destroy, id: content.to_param
        }.to change(Content, :count).by(-1)
      end

      it "should redirect to the contents list" do
        delete :destroy, id: content.to_param
        response.should redirect_to contents_url
      end
    end

    context "as random user" do
      it "should not destroy the requested content" do
        content
        expect {
          delete :destroy, id: content.to_param
        }.to change(Content, :count).by 0
      end
    end
  end

end
