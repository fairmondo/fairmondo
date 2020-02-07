#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  describe "POST 'create'" do
    before :each do
      article = create :article
      @attributes = attributes_for(:feedback, article_id: article.id)
    end

    describe 'for non-signed-in users' do
      it 'should create a feedback with variety report_article' do
        assert_difference 'Feedback.count', 1 do
          post :create, params:{ feedback: @attributes }
        end
      end

      it 'should create no feedback if recaptcha is not verified' do
        @controller.stubs(:verify_recaptcha).returns(false)
        assert_no_difference 'Feedback.count' do
          post :create, params:{ feedback: @attributes }
        end
      end
    end
  end
end
