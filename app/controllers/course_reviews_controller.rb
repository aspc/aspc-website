class CourseReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]

  # GET /reviews/:id
  def show
    @course_review = CourseReview.find_by(:id => params[:id])
  end

  # GET /reviews/course/:id/new
  def new
    course_id = params[:course_id]
    @course = Course.find_by(:id => course_id)

    @course_review = CourseReview.new
  end

  def create
    @course_review = CourseReview.new(
       :overall_rating => review_params[:overall_rating],
       :inclusivity_rating => review_params[:inclusivity_rating],
       :challenge_rating => review_params[:challenge_rating],
       :work_per_week => review_params[:work_per_week],
       :comments => review_params[:comments],
       :course_id => review_params[:course_id],
       :instructor_id => review_params[:instructor_id]
    )

    course_id = review_params[:course_id]
    @course = @course_review.course #Course.find_by(:id => course_id)

    respond_to do |format|
      if @course_review.save
        format.html { redirect_to @course_review.course, notice: 'Your course review has been submitted successfully.' }
        format.json { render json: @course_review, status: :ok }
      else
        format.html { render :new }
        format.json { render json: @course_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def review_params
    params
        .require(:course_review)
        .permit(:overall_rating, :challenge_rating, :inclusivity_rating, :work_per_week, :comments,
                :course_id, :instructor_id, :id)
  end
end
