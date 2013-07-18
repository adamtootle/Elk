require 'test_helper'

class XmlControllerTest < ActionController::TestCase
  test "should get mobileconfig" do
    get :mobileconfig
    assert_response :success
  end

end
