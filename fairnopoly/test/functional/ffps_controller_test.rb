require 'test_helper'

class FfpsControllerTest < ActionController::TestCase
  setup do
    @ffp = ffps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ffps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ffp" do
    assert_difference('Ffp.count') do
      post :create, :ffp => @ffp.attributes
    end

    assert_redirected_to ffp_path(assigns(:ffp))
  end

  test "should show ffp" do
    get :show, :id => @ffp
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ffp
    assert_response :success
  end

  test "should update ffp" do
    put :update, :id => @ffp, :ffp => @ffp.attributes
    assert_redirected_to ffp_path(assigns(:ffp))
  end

  test "should destroy ffp" do
    assert_difference('Ffp.count', -1) do
      delete :destroy, :id => @ffp
    end

    assert_redirected_to ffps_path
  end
end
