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

describe ArticleTemplatesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  def valid_attributes
    article_attributes = FactoryGirl::attributes_for(:article, :category_ids => [FactoryGirl.create(:category).id])
    template_attributes = FactoryGirl.attributes_for(:article_template)
    template_attributes[:article_attributes] = article_attributes
    template_attributes
  end

  def invalid_attributes
    valid_attributes.merge name: nil
  end

  let :valid_update_attributes do
    attrs = valid_attributes
    attrs[:article_attributes].merge!(:id => @article_template.article.id)
    attrs
  end

  describe "GET new" do
    it "assigns a new article_template as @article_template" do
      get :new, {}
      assigns(:article_template).should be_a_new(ArticleTemplate)
    end
  end

  describe "GET edit" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :user => @user)
    end

    it "assigns the requested article_template as @article_template" do
      get :edit, {:id => @article_template.to_param}
      assigns(:article_template).should eq(@article_template)
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new ArticleTemplate" do
        expect {
          post :create, article_template: valid_attributes
        }.to change(ArticleTemplate, :count).by(1)
      end

      it "assigns a newly created article_template as @article_template" do
        post :create, article_template: valid_attributes
        assigns(:article_template).should be_an ArticleTemplate
        assigns(:article_template).should be_persisted
      end

      it "redirects to the collection" do
        post :create, article_template: valid_attributes
        response.should redirect_to user_url @user, anchor: "my_article_templates"
      end
    end

    context "with invalid params" do
      it "should try to save the images anyway" do
        attrs = invalid_attributes
        attrs[:article_attributes][:images_attributes] = {"0" => {"image" => fixture_file_upload('/test.png')}}

        controller.should_receive(:save_images).and_call_original
        Image.any_instance.should_receive :save

        post :create, article_template: attrs
      end

      it "should re-render the :new template" do
        post :create, article_template: invalid_attributes
        response.should render_template "new"
      end
    end
  end

  describe "PUT update" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :user => @user)
    end

    context "with valid params" do

      it "updates the requested article_template" do
        put :update, {:id => @article_template.to_param, "article_template" => {"article_attributes" => {"title" => "updated Title", "id" => @article_template.article.id}}}
        @article_template.reload
        @article_template.article.title.should == "updated Title"
      end

      it "assigns the requested article_template as @article_template" do
        put :update, {:id => @article_template.to_param, :article_template => valid_update_attributes}
        assigns(:article_template).should eq(@article_template)
      end

      it "redirects to the collection" do
        put :update, {:id => @article_template.to_param, :article_template => valid_update_attributes}
        response.should redirect_to(user_url(@user, :anchor => "my_article_templates"))
      end
    end

    context "with invalid params" do
      it "should try to save the images anyway" do
        controller.should_receive(:save_images)
        put :update, {id: @article_template.to_param, article_template: invalid_attributes}
      end

      it "should re-render the :edit template" do
        put :update, {id: @article_template.to_param, article_template: invalid_attributes}
        response.should render_template "edit"
      end
    end
  end

  describe "DELETE destroy" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :user => @user)
    end

    it "destroys the requested article_template" do
      expect {
        delete :destroy, id: @article_template.to_param
      }.to change(ArticleTemplate, :count).by(-1)
    end

    it "redirects to the article_templates list" do
      delete :destroy, {:id => @article_template.to_param}
      response.should redirect_to user_url(@user, anchor: "my_article_templates")
    end
  end

end
