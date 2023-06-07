require "test_helper"

class EvaluablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evaluable = evaluables(:one)
  end

  test "should get index" do
    get evaluables_url
    assert_response :success
  end

  test "should get new" do
    get new_evaluable_url
    assert_response :success
  end

  test "should create evaluable" do
    assert_difference("Evaluable.count") do
      post evaluables_url, params: { evaluable: {  } }
    end

    assert_redirected_to evaluable_url(Evaluable.last)
  end

  test "should show evaluable" do
    get evaluable_url(@evaluable)
    assert_response :success
  end

  test "should get edit" do
    get edit_evaluable_url(@evaluable)
    assert_response :success
  end

  test "should update evaluable" do
    patch evaluable_url(@evaluable), params: { evaluable: {  } }
    assert_redirected_to evaluable_url(@evaluable)
  end

  test "should destroy evaluable" do
    assert_difference("Evaluable.count", -1) do
      delete evaluable_url(@evaluable)
    end

    assert_redirected_to evaluables_url
  end
end
