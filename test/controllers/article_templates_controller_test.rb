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

describe ArticleTemplatesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  def valid_attributes
    FactoryGirl.attributes_for(:article_template, category_ids: [FactoryGirl.create(:category).id])
  end

  def invalid_attributes
    valid_attributes.merge template_name: nil
  end

  let :valid_update_attributes do
    valid_attributes
  end

  describe "GET new" do
    before { get :new }
    it "renders template new" do
      assert_template(:new)
    end
  end

  describe "GET edit" do

    before do
      @article_template = FactoryGirl.create(:article_template, :seller => @user)
    end

    it "assigns the requested article_template as @article_template" do
      get :edit, {:id => @article_template.to_param}
      assigns(:article_template).must_equal(@article_template)
      assert_template(:edit)
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new ArticleTemplate" do
        assert_difference 'Article.unscoped.count', 1 do
          post :create, article: valid_attributes
        end
      end

      it "assigns a newly created article_template as @article_template" do
        post :create, article: valid_attributes
        assigns(:article_template).must_be_instance_of Article
        assigns(:article_template).persisted?.must_equal true
      end

      it "redirects to the collection" do
        post :create, article: valid_attributes
        assert_redirected_to(user_url @user, anchor: "my_article_templates")
      end
    end

    context "with invalid params" do
      it "should try to save the images anyway" do
        attrs = invalid_attributes
        attrs[:images_attributes] = {"0" => {"image" => fixture_file_upload('/test.png')}}

        Image.any_instance.expects(:save)

        post :create, article: attrs
      end

      it "should re-render the :new template" do
        post :create, article: invalid_attributes
        assert_template(:new)
      end
    end
  end

  describe "PUT update" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :seller => @user)
    end

    context "with valid params" do

      it "updates the requested article_template" do
        put :update, :id => @article_template.to_param, "article" => {"title" => "updated Title" }
        @article_template.reload
        @article_template.title.must_equal "updated Title"
      end

      it "assigns the requested article_template as @article_template" do
        put :update, {:id => @article_template.to_param, :article => valid_update_attributes}
        assigns(:article_template).must_equal(@article_template)
      end

      it "redirects to the collection" do
        put :update, {:id => @article_template.to_param, :article => valid_update_attributes}
        assert_redirected_to(user_url(@user, :anchor => "my_article_templates"))
      end
    end

    context "with invalid params" do
      it "should try to save the images anyway" do
        @controller.expects(:save_images)
        put :update, {id: @article_template.to_param, article: invalid_attributes}
      end

      it "should re-render the :edit template" do
        put :update, {id: @article_template.to_param, article: invalid_attributes}
        assert_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :seller => @user)
    end

    it "destroys the requested article_template" do
      assert_difference 'Article.unscoped.count', -1 do
        delete :destroy, id: @article_template.to_param
      end
    end

    it "redirects to the article_templates list" do
      delete :destroy, {:id => @article_template.to_param}
       assert_redirected_to(user_url(@user, anchor: "my_article_templates"))
    end
  end

end
