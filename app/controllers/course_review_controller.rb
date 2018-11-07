class CourseReviewController < ApplicationController
  def show
    @course_review = CourseReview.find_by(:id => params[:id])
  end

  def create
  end
end
