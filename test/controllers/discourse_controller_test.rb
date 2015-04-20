require_relative '../test_helper'

describe DiscourseController do
  it 'shoud GET discourse/sso' do
    get :sso
    assert_response :found
  end

  describe 'for a logged out user' do
    it 'should redirect to login page' do
      get :sso, sso: 'bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI=\n',
                sig: '2828aa29899722b35a2f191d34ef9b3ce695e0e6eeec47deb46d588d70c7cb56'
      response.must redirect_to new_user_session_path
    end
  end

  describe 'for a logged in user' do
    before do
      @user = FactoryGirl.create(:user, email: 'test@test.com', nickname: 'samsam', create_standard_address: false)
      sign_in @user
    end

    it 'should redirect to discourse forum with right params' do
      get :sso, sso: 'bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI=\n',
                sig: 'a265194763a84c4d9ad1f17e113f2bbc8d356441d44ec9dec13ad442928547d4'

      response.must redirect_to 'http://test.de/sessions/sso_login?sso=bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGImbmFtZT0r%0AJnVzZXJuYW1lPXNhbXNhbSZlbWFpbD10ZXN0JTQwdGVzdC5jb20mZXh0ZXJu%0AYWxfaWQ9MQ%3D%3D%0A&sig=08c123f00949f1abe5305cba33e30c81d2211f3ee43d819415d6c7dca949140f'
    end
  end
end
