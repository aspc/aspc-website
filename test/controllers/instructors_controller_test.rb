require 'test_helper'

class InstructorsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get instructors_show_url
    assert_response :success
  end

end
