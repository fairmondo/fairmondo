#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticleTemplatesControllerTest < ActionController::TestCase
  before :each do
    @user = create(:user)
    sign_in @user
  end

  def valid_attributes
    attributes_for(:article_template, category_ids: [create(:category).id])
  end

  def invalid_attributes
    valid_attributes.merge article_template_name: nil
  end

  let :valid_update_attributes do
    valid_attributes
  end

  describe 'GET new' do
    before { get :new }
    it 'renders template new' do
      assert_template(:new)
    end
  end

  describe 'GET edit' do
    before do
      @article_template = create(:article_template, seller: @user)
    end

    it 'assigns the requested article_template as @article_template' do
      get :edit, params:{ id: @article_template.to_param }
      assigns(:article_template).must_equal(@article_template)
      assert_template(:edit)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new ArticleTemplate' do
        assert_difference 'Article.unscoped.count', 1 do
          post :create, params:{ article: valid_attributes }
        end
      end

      it 'assigns a newly created article_template as @article_template' do
        post :create, params:{ article: valid_attributes }
        assigns(:article_template).must_be_instance_of Article
        assigns(:article_template).persisted?.must_equal true
      end

      it 'redirects to the collection' do
        post :create, params:{ article: valid_attributes }
        assert_redirected_to(user_url @user, anchor: 'my_article_templates')
      end
    end

    context 'with invalid params' do
      it 'should try to save the images anyway' do
        attrs = invalid_attributes
        attrs[:images_attributes] = { '0' => { 'image' => fixture_file_upload('/test.png') } }

        Image.any_instance.expects(:save)

        post :create, params:{ article: attrs }
      end

      it 'should re-render the :new template' do
        post :create, params:{ article: invalid_attributes }
        assert_template(:new)
      end
    end
  end

  describe 'PUT update' do
    before :each do
      @article_template = create(:article_template, seller: @user)
    end

    context 'with valid params' do
      it 'updates the requested article_template' do
        put :update, params: { id: @article_template.to_param, article: { title: 'updated Title' } }
        @article_template.reload
        @article_template.title.must_equal 'updated Title'
      end

      it 'assigns the requested article_template as @article_template' do
        put :update, params:{ id: @article_template.to_param, article: valid_update_attributes }
        assigns(:article_template).must_equal(@article_template)
      end

      it 'redirects to the collection' do
        put :update, params:{ id: @article_template.to_param, article: valid_update_attributes }
        assert_redirected_to(user_url(@user, anchor: 'my_article_templates'))
      end
    end

    context 'with invalid params' do
      it 'should try to save the images anyway' do
        @controller.expects(:save_images)
        put :update, params:{ id: @article_template.to_param, article: invalid_attributes }
      end

      it 'should re-render the :edit template' do
        put :update, params:{ id: @article_template.to_param, article: invalid_attributes }
        assert_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @article_template = create(:article_template, seller: @user)
    end

    it 'destroys the requested article_template' do
      assert_difference 'Article.unscoped.count', -1 do
        delete :destroy, params:{ id: @article_template.to_param }
      end
    end

    it 'redirects to the article_templates list' do
      delete :destroy, params:{ id: @article_template.to_param }
      assert_redirected_to(user_url(@user, anchor: 'my_article_templates'))
    end
  end
end
