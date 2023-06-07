require "application_system_test_case"

class EvaluablesTest < ApplicationSystemTestCase
  setup do
    @evaluable = evaluables(:one)
  end

  test "visiting the index" do
    visit evaluables_url
    assert_selector "h1", text: "Evaluables"
  end

  test "should create evaluable" do
    visit evaluables_url
    click_on "New evaluable"

    click_on "Create Evaluable"

    assert_text "Evaluable was successfully created"
    click_on "Back"
  end

  test "should update Evaluable" do
    visit evaluable_url(@evaluable)
    click_on "Edit this evaluable", match: :first

    click_on "Update Evaluable"

    assert_text "Evaluable was successfully updated"
    click_on "Back"
  end

  test "should destroy Evaluable" do
    visit evaluable_url(@evaluable)
    click_on "Destroy this evaluable", match: :first

    assert_text "Evaluable was successfully destroyed"
  end
end
