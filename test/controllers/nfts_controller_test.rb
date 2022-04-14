require "test_helper"

class NftsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get nfts_show_url
    assert_response :success
  end

  test "should get new" do
    get nfts_new_url
    assert_response :success
  end

  test "should get create" do
    get nfts_create_url
    assert_response :success
  end
end
