require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get top" do
    get :top
    assert_response :success
  end

  test "should get wires" do
    get :wires
    assert_response :success
  end

end
