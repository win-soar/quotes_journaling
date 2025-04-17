require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get quotes_index_url
    assert_response :success
  end

  test "should get create" do
    get quotes_create_url
    assert_response :success
  end
end
