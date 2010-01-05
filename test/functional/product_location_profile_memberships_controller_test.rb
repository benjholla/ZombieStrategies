require 'test_helper'

class ProductLocationProfileMembershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_location_profile_memberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_location_profile_membership" do
    assert_difference('ProductLocationProfileMembership.count') do
      post :create, :product_location_profile_membership => { }
    end

    assert_redirected_to product_location_profile_membership_path(assigns(:product_location_profile_membership))
  end

  test "should show product_location_profile_membership" do
    get :show, :id => product_location_profile_memberships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => product_location_profile_memberships(:one).to_param
    assert_response :success
  end

  test "should update product_location_profile_membership" do
    put :update, :id => product_location_profile_memberships(:one).to_param, :product_location_profile_membership => { }
    assert_redirected_to product_location_profile_membership_path(assigns(:product_location_profile_membership))
  end

  test "should destroy product_location_profile_membership" do
    assert_difference('ProductLocationProfileMembership.count', -1) do
      delete :destroy, :id => product_location_profile_memberships(:one).to_param
    end

    assert_redirected_to product_location_profile_memberships_path
  end
end
