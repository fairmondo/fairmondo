require_relative "../test_helper"

describe DiscourseController do
  it 'shoud GET discourse/sso' do
    get :sso
    assert_response :found
  end

  describe 'for a logged out user' do
    it 'should redirect to login page' do
      get :sso, sso: 'bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI%3D%0A',
        sig: '46e749cd26dcabc84eed323ff31f830da674dc87c77a2fcb1b296f76402ea900'
      response.must redirect_to new_user_session_path
    end
  end

  describe 'for a logged in user' do
    before do
      @user = FactoryGirl.create(:user, email: 'test@test.com', nickname: 'samsam')
      sign_in @user
    end

    it 'should redirect to discourse forum with right params' do
      get :sso, sso: 'bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI%3D%0A',
        sig: '46e749cd26dcabc84eed323ff31f830da674dc87c77a2fcb1b296f76402ea900'
      secret = $DISCOURSE_SECRET
      @sso = SingleSignOn.parse(request.query_string, secret)
      @sso.email = @user.email
      @sso.name = @user.fullname if @user.fullname
      @sso.username = @user.nickname
      @sso.external_id = @user.id
      @sso.sso_secret = secret

      response.must redirect_to @sso.to_url($DISCOURSE_URL)
    end
  end
end
