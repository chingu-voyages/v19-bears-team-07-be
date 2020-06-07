require 'test_helper'

class AppTest < ActiveSupport::TestCase
  test "an app with no ratings is calculated to have 0 ratings from 1 to 5" do
    app = apps(:one)
    result = AppContext.find_by(id: app.id)
    expected = {
      1 => 0,
      2 => 0,
      3 => 0,
      4 => 0,
      5 => 0,
    }
    assert_equal(expected, result["ratings"])
  end

  test "an app with no ratings from it's specified `logged-in` user is given a user-rating of 0" do 
    app = apps(:one)
    user = users(:one)
    result = AppContext.find_by(id: app.id, current_user: user)
    expected = 0
    assert_equal(expected, result["score"])
  end
end
