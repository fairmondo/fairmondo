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



module Tinycms
  describe ContentsController do

    def valid_attributes
      {}
    end

    def valid_session
      {}
    end

    describe "GET index" do
      it "assigns all contents as @contents" do
        content = Content.create! valid_attributes
        get :index, {}, valid_session
        assigns(:contents).should eq([content])
      end
    end

    describe "GET show" do
      it "assigns the requested content as @content" do
        content = Content.create! valid_attributes
        get :show, {:id => content.to_param}, valid_session
        assigns(:content).should eq(content)
      end
    end

    describe "GET new" do
      it "assigns a new content as @content" do
        get :new, {}, valid_session
        assigns(:content).should be_a_new(Content)
      end
    end

    describe "GET edit" do
      it "assigns the requested content as @content" do
        content = Content.create! valid_attributes
        get :edit, {:id => content.to_param}, valid_session
        assigns(:content).should eq(content)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Content" do
          expect {
            post :create, {:content => valid_attributes}, valid_session
          }.to change(Content, :count).by(1)
        end

        it "assigns a newly created content as @content" do
          post :create, {:content => valid_attributes}, valid_session
          assigns(:content).should be_a(Content)
          assigns(:content).should be_persisted
        end

        it "redirects to the created content" do
          post :create, {:content => valid_attributes}, valid_session
          response.should redirect_to(Content.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved content as @content" do
          # Trigger the behavior that occurs when invalid params are submitted
          Content.any_instance.stub(:save).and_return(false)
          post :create, {:content => {}}, valid_session
          assigns(:content).should be_a_new(Content)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Content.any_instance.stub(:save).and_return(false)
          post :create, {:content => {}}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested content" do
          content = Content.create! valid_attributes
          # Assuming there are no other contents in the database, this
          # specifies that the Content created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Content.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => content.to_param, :content => {'these' => 'params'}}, valid_session
        end

        it "assigns the requested content as @content" do
          content = Content.create! valid_attributes
          put :update, {:id => content.to_param, :content => valid_attributes}, valid_session
          assigns(:content).should eq(content)
        end

        it "redirects to the content" do
          content = Content.create! valid_attributes
          put :update, {:id => content.to_param, :content => valid_attributes}, valid_session
          response.should redirect_to(content)
        end
      end

      describe "with invalid params" do
        it "assigns the content as @content" do
          content = Content.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Content.any_instance.stub(:save).and_return(false)
          put :update, {:id => content.to_param, :content => {}}, valid_session
          assigns(:content).should eq(content)
        end

        it "re-renders the 'edit' template" do
          content = Content.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Content.any_instance.stub(:save).and_return(false)
          put :update, {:id => content.to_param, :content => {}}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested content" do
        content = Content.create! valid_attributes
        expect {
          delete :destroy, {:id => content.to_param}, valid_session
        }.to change(Content, :count).by(-1)
      end

      it "redirects to the contents list" do
        content = Content.create! valid_attributes
        delete :destroy, {:id => content.to_param}, valid_session
        response.should redirect_to(contents_url)
      end
    end

  end
end
