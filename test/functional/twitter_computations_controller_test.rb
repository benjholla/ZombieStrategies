require 'test_helper'

class TwitterComputationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:twitter_computations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create twitter_computation" do
    assert_difference('TwitterComputation.count') do
      post :create, :twitter_computation => { }
    end

    assert_redirected_to twitter_computation_path(assigns(:twitter_computation))
  end

  test "should show twitter_computation" do
    get :show, :id => twitter_computations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => twitter_computations(:one).to_param
    assert_response :success
  end

  test "should update twitter_computation" do
    put :update, :id => twitter_computations(:one).to_param, :twitter_computation => { }
    assert_redirected_to twitter_computation_path(assigns(:twitter_computation))
  end

  test "should destroy twitter_computation" do
    assert_difference('TwitterComputation.count', -1) do
      delete :destroy, :id => twitter_computations(:one).to_param
    end

    assert_redirected_to twitter_computations_path
  end
end
