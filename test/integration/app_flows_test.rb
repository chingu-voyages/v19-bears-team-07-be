require 'test_helper'

class AppFlowsTest < ActionDispatch::IntegrationTest
  test "Can get all apps" do
    get "/apps"
    assert_response :success

    length = App.all.length
    assert_equal(length, response.parsed_body.length)
  end
end
