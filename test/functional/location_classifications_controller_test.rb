require 'test_helper'

class LocationClassificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:location_classifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location_classification" do
    assert_difference('LocationClassification.count') do
      post :create, :location_classification => { }
    end

    assert_redirected_to location_classification_path(assigns(:location_classification))
  end

  test "should show location_classification" do
    get :show, :id => location_classifications(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => location_classifications(:one).to_param
    assert_response :success
  end

  test "should update location_classification" do
    put :update, :id => location_classifications(:one).to_param, :location_classification => { }
    assert_redirected_to location_classification_path(assigns(:location_classification))
  end

  test "should destroy location_classification" do
    assert_difference('LocationClassification.count', -1) do
      delete :destroy, :id => location_classifications(:one).to_param
    end

    assert_redirected_to location_classifications_path
  end
end
