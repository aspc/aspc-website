require "application_system_test_case"

class HousingReviewsTest < ApplicationSystemTestCase
  setup do
    @housing_review = housing_reviews(:one)
  end

  test "visiting the index" do
    visit housing_reviews_url
    assert_selector "h1", text: "Housing Reviews"
  end

  test "creating a Housing review" do
    visit housing_reviews_url
    click_on "New Housing Review"

    fill_in "Comments", with: @housing_review.comments
    fill_in "Create", with: @housing_review.create
    fill_in "Index", with: @housing_review.index
    fill_in "Layout rating", with: @housing_review.layout_rating
    fill_in "New", with: @housing_review.new
    fill_in "Quiet rating", with: @housing_review.quiet_rating
    fill_in "Show", with: @housing_review.show
    fill_in "Temperature rating", with: @housing_review.temperature_rating
    click_on "Create Housing review"

    assert_text "Housing review was successfully created"
    click_on "Back"
  end

  test "updating a Housing review" do
    visit housing_reviews_url
    click_on "Edit", match: :first

    fill_in "Comments", with: @housing_review.comments
    fill_in "Create", with: @housing_review.create
    fill_in "Index", with: @housing_review.index
    fill_in "Layout rating", with: @housing_review.layout_rating
    fill_in "New", with: @housing_review.new
    fill_in "Quiet rating", with: @housing_review.quiet_rating
    fill_in "Show", with: @housing_review.show
    fill_in "Temperature rating", with: @housing_review.temperature_rating
    click_on "Update Housing review"

    assert_text "Housing review was successfully updated"
    click_on "Back"
  end

  test "destroying a Housing review" do
    visit housing_reviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Housing review was successfully destroyed"
  end
end
