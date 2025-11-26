require "test_helper"

class LogEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get log_events_index_url
    assert_response :success
  end

  test "should get search" do
    get log_events_search_url
    assert_response :success
  end
end
