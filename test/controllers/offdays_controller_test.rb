require 'test_helper'

class OffdaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offday = offdays(:one)
  end

  test "should get index" do
    get offdays_url
    assert_response :success
  end

  test "should get new" do
    get new_offday_url
    assert_response :success
  end

  test "should create offday" do
    assert_difference('Offday.count') do
      post offdays_url, params: { offday: { date_off: @offday.date_off, note: @offday.note } }
    end

    assert_redirected_to offday_url(Offday.last)
  end

  test "should show offday" do
    get offday_url(@offday)
    assert_response :success
  end

  test "should get edit" do
    get edit_offday_url(@offday)
    assert_response :success
  end

  test "should update offday" do
    patch offday_url(@offday), params: { offday: { date_off: @offday.date_off, note: @offday.note } }
    assert_redirected_to offday_url(@offday)
  end

  test "should destroy offday" do
    assert_difference('Offday.count', -1) do
      delete offday_url(@offday)
    end

    assert_redirected_to offdays_url
  end
end
