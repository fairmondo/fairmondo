require_relative "../test_helper"

describe DiscourseController do
  it 'shoud GET discourse/sso' do
    get :sso
    assert_response :found
  end

  it 'should redirect to discourse' do
    get :sso, sso: 'bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGImbmFtZT1z%0AYW0mdXNlcm5hbWU9c2Ftc2FtJmVtYWlsPXRlc3QlNDB0ZXN0LmNvbSZleHRl%0Acm5hbF9pZD1oZWxsbzEyMw%3D%3D%0A',
              sig: '1c884222282f3feacd76802a9dd94e8bc8deba5d619b292bed75d63eb3152c0b'
    response.must redirect_to new_user_session_path
  end
end
