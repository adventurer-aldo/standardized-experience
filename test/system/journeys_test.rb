require "application_system_test_case"

class JourneysTest < ApplicationSystemTestCase
  setup do
    @journey = journeys(:one)
  end

  test "visiting the index" do
    visit journeys_url
    assert_selector "h1", text: "Journeys"
  end

  test "should create journey" do
    visit journeys_url
    click_on "New journey"

    click_on "Create Journey"

    assert_text "Journey was successfully created"
    click_on "Back"
  end

  test "should update Journey" do
    visit journey_url(@journey)
    click_on "Edit this journey", match: :first

    click_on "Update Journey"

    assert_text "Journey was successfully updated"
    click_on "Back"
  end

  test "should destroy Journey" do
    visit journey_url(@journey)
    click_on "Destroy this journey", match: :first

    assert_text "Journey was successfully destroyed"
  end
end
