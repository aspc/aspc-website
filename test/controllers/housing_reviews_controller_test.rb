require 'test_helper'

class HousingReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @housing_review = housing_reviews(:one)
  end

  test "should get index" do
    get housing_reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_housing_review_url
    assert_response :success
  end

  test "should create housing_review" do
    assert_difference('HousingReview.count') do
      post housing_reviews_url, params: { housing_review: { comments: @housing_review.comments, create: @housing_review.create, index: @housing_review.index, layout_rating: @housing_review.layout_rating, new: @housing_review.new, quiet_rating: @housing_review.quiet_rating, show: @housing_review.show, temperature_rating: @housing_review.temperature_rating } }
    end

    assert_redirected_to housing_review_url(HousingReview.last)
  end

  test "should show housing_review" do
    get housing_review_url(@housing_review)
    assert_response :success
  end

  test "should get edit" do
    get edit_housing_review_url(@housing_review)
    assert_response :success
  end

  test "should update housing_review" do
    patch housing_review_url(@housing_review), params: { housing_review: { comments: @housing_review.comments, create: @housing_review.create, index: @housing_review.index, layout_rating: @housing_review.layout_rating, new: @housing_review.new, quiet_rating: @housing_review.quiet_rating, show: @housing_review.show, temperature_rating: @housing_review.temperature_rating } }
    assert_redirected_to housing_review_url(@housing_review)
  end

  test "should destroy housing_review" do
    assert_difference('HousingReview.count', -1) do
      delete housing_review_url(@housing_review)
    end

    assert_redirected_to housing_reviews_url
  end
end
