#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe FeedbacksController do
  describe "POST 'create'" do
    before :each do
      @attributes = FactoryGirl.attributes_for :feedback, :report_article
    end

    describe 'for non-signed-in users' do
      it 'should create a feedback with variety report_article' do
        assert_difference 'Feedback.count', 1 do
          post :create, feedback: @attributes
        end
      end

      it 'should create a feedback with variety report_article' do
        @controller.stubs(:verify_recaptcha).returns(false)
        assert_no_difference 'Feedback.count', 1 do
          post :create, feedback: @attributes
        end
      end
    end
  end
end
