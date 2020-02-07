#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ToolboxControllerTest < ActionController::TestCase
  let(:user) { create :user }

  # render_views

  describe "GET 'session_expired'" do
    describe 'as json' do
      it 'should be successful' do
        get :session_expired, params:{ format: :json }
        assert_response :success
      end
    end

    describe 'as html' do
      it 'should fail' do
        assert_raises(ActionController::UnknownFormat) { get :session_expired }
      end
    end
  end

  describe "GET 'confirm'" do
    describe 'as js' do
      it 'should be successful' do
        get :confirm, params: { format: :js }, xhr: true
        assert_response :success
      end
    end

    describe 'as html' do
      it 'should fail' do
        assert_raises(ActionController::UnknownFormat) { get :confirm }
      end
    end
  end

  describe "GET 'reload'" do
    it 'should be successful' do
      get :reload
      assert_response :success
    end

    it 'should not render a layout' do
      get :reload
      assert_template layout: false
    end
  end

  describe "GET 'healthcheck'" do
    it 'should be successful' do
      get :healthcheck
      assert_response :success
    end

    it 'should not render a layout' do
      get :healthcheck
      assert_template layout: false
    end
  end

  describe '#newsletter_status ' do
    before do
      sign_in user
    end
    it 'should be successful' do
      # CleverreachAPI.expects(:get_status).with(user)
      fixture = File.read('test/fixtures/cleverreach_get_by_mail_success.xml')
      Savon::Client.any_instance.expects(:call).returns(fixture)
      get :newsletter_status, params:{ format: :json }
      assert_response :success
    end

    it 'should not render a layout' do
      CleverreachAPI.expects(:get_status).with(user)
      get :newsletter_status, params:{ format: :json }
      assert_template layout: false
    end

    it 'should call the Cleverreach API with the logged in user' do
      CleverreachAPI.expects(:get_status).with(user)
      get :newsletter_status, params:{ format: :json }
    end
  end

  describe 'PUT reindex' do
    before do
      sign_in user
    end

    describe 'for normal users' do
      it 'should not be allowed' do
        assert_raises(Pundit::NotAuthorizedError) { put :reindex, params: { article_id: 1 } }
      end
    end

    describe 'for admin users' do
      let(:user) { create :admin_user }

      it 'should do something' do
        article = create :article
        Indexer.expects(:index_article).with(article)

        request.env['HTTP_REFERER'] = '/'
        put :reindex, params:{ article_id: article.id }
      end
    end
  end
end
