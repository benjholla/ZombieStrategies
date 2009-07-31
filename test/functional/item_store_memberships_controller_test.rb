require 'test_helper'

class ItemStoreMembershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_store_memberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_store_membership" do
    assert_difference('ItemStoreMembership.count') do
      post :create, :item_store_membership => { }
    end

    assert_redirected_to item_store_membership_path(assigns(:item_store_membership))
  end

  test "should show item_store_membership" do
    get :show, :id => item_store_memberships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => item_store_memberships(:one).to_param
    assert_response :success
  end

  test "should update item_store_membership" do
    put :update, :id => item_store_memberships(:one).to_param, :item_store_membership => { }
    assert_redirected_to item_store_membership_path(assigns(:item_store_membership))
  end

  test "should destroy item_store_membership" do
    assert_difference('ItemStoreMembership.count', -1) do
      delete :destroy, :id => item_store_memberships(:one).to_param
    end

    assert_redirected_to item_store_memberships_path
  end
end
