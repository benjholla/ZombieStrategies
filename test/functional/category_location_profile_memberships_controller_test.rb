require 'test_helper'

class CategoryLocationProfileMembershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:category_location_profile_memberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category_location_profile_membership" do
    assert_difference('CategoryLocationProfileMembership.count') do
      post :create, :category_location_profile_membership => { }
    end

    assert_redirected_to category_location_profile_membership_path(assigns(:category_location_profile_membership))
  end

  test "should show category_location_profile_membership" do
    get :show, :id => category_location_profile_memberships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => category_location_profile_memberships(:one).to_param
    assert_response :success
  end

  test "should update category_location_profile_membership" do
    put :update, :id => category_location_profile_memberships(:one).to_param, :category_location_profile_membership => { }
    assert_redirected_to category_location_profile_membership_path(assigns(:category_location_profile_membership))
  end

  test "should destroy category_location_profile_membership" do
    assert_difference('CategoryLocationProfileMembership.count', -1) do
      delete :destroy, :id => category_location_profile_memberships(:one).to_param
    end

    assert_redirected_to category_location_profile_memberships_path
  end
end
