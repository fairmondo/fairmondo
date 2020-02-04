#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class CommentsControllerTest < ActionController::TestCase
  describe 'GET comments on library' do
    before :each do
      @library = create :library, public: true
      @user = create :user
      @comment = create :comment, text: 'Test comment', commentable: @library, user: @user
    end

    it 'should return the comments of the library for guests' do
      xhr(:get, :index, library_id: @library.id,
                        comments_page: 1)

      assert_response :success
    end

    it 'should return the comments of the library for logged in users' do
      sign_in @user
      xhr(:get, :index, library_id: @library.id,
                        comments_page: 1)

      assert_response :success
    end

    it 'should render the paginated partial if the page param is there' do
      xhr(:get, :index, library_id: @library.id,
                        comments_page: 1)

      assert_template 'comments/_index_paginated'
    end
  end

  describe 'POST comment on library' do
    before :each do
      @library = create :library
      @user = create :user
      sign_in @user
    end

    describe 'with valid params' do
      it 'should allow posting using ajax' do
        xhr(:post, :create, comment: { text: 'test' },
                            library_id: @library.id)

        assert_response :success
        assert_nil(assigns(:message))
      end

      it 'increases the counter cache' do
        assert_difference '@library.comments_count', 1 do
          xhr(:post, :create, comment: { text: 'test' },
                              library_id: @library.id)

          @library.reload
        end
      end
    end

    describe 'with invalid params' do
      it 'does not increase the comment count' do
        assert_difference '@library.comments.count', 0 do
          post :create, comment: { text: '' },
                        library_id: @library.id + 1,
                        format: :js
        end
      end

      it 'renders the new template' do
        post :create, comment: { text: '' },
                      library_id: @library.id + 1,
                      format: :js
        assert_template 'new'
      end
    end
  end

  describe 'DELETE comment on library' do
    before :each do
      @library = create :library
      @user = create :user
      sign_in @user
      @comment = create :comment, text: 'Test comment', commentable: @library, user: @user
    end

    it 'it should remove the comment' do
      delete :destroy, id: @comment.id,
                       library_id: @library.id,
                       format: :js

      assert_response :success
    end
  end
end
