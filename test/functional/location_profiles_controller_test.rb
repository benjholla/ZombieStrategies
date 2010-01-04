require 'test_helper'

class LocationProfilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:location_profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location_profile" do
    assert_difference('LocationProfile.count') do
      post :create, :location_profile => { }
    end

    assert_redirected_to location_profile_path(assigns(:location_profile))
  end

  test "should show location_profile" do
    get :show, :id => location_profiles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => location_profiles(:one).to_param
    assert_response :success
  end

  test "should update location_profile" do
    put :update, :id => location_profiles(:one).to_param, :location_profile => { }
    assert_redirected_to location_profile_path(assigns(:location_profile))
  end

  test "should destroy location_profile" do
    assert_difference('LocationProfile.count', -1) do
      delete :destroy, :id => location_profiles(:one).to_param
    end

    assert_redirected_to location_profiles_path
  end
end
