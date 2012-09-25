require 'test_helper'

class UsereventsControllerTest < ActionController::TestCase
  setup do
    @userevent = userevents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:userevents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create userevent" do
    assert_difference('Userevent.count') do
      post :create, :userevent => @userevent.attributes
    end

    assert_redirected_to userevent_path(assigns(:userevent))
  end

  test "should show userevent" do
    get :show, :id => @userevent
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @userevent
    assert_response :success
  end

  test "should update userevent" do
    put :update, :id => @userevent, :userevent => @userevent.attributes
    assert_redirected_to userevent_path(assigns(:userevent))
  end

  test "should destroy userevent" do
    assert_difference('Userevent.count', -1) do
      delete :destroy, :id => @userevent
    end

    assert_redirected_to userevents_path
  end
end
