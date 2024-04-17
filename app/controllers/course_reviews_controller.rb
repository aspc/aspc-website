class CourseReviewsController < ApplicationController
  before_action :authenticate_user!

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

  # DELETE /reviews/course/:course_id/:
  def destroy
    course_review = CourseReview.find_by(:id => params[:id])
    if current_user.id == course_review.user_id
      course_review.destroy
    end

    redirect_to course_path(course_review.course), notice: "Course review was successfully deleted."
  end

  def show_course_reviews
    @academic_terms = AcademicTerm.current_academic_year
    @departments = Department.all
  end

  def show_instructor_reviews
    @departments = Department.all
  end

  def create
    @course_review = CourseReview.new(
       :overall_rating => review_params[:overall_rating],
       :inclusivity_rating => review_params[:inclusivity_rating],
       :total_cost => review_params[:total_cost],
       :challenge_rating => review_params[:challenge_rating],
       :work_per_week => review_params[:work_per_week],
       :comments => review_params[:comments],
       :course_id => review_params[:course_id],
       :instructor_id => review_params[:instructor_id],
       :user_id => current_user.id,
    )

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

  def search_course_reviews
    # param initialization
    # TODO: Turn back on search by department
    # department_code = Department.find_by(:name => params[:department]).code unless params[:department].empty?
    number = params[:number].to_i rescue nil unless params[:number].empty?
    keywords = params[:keywords].split rescue nil unless params[:keywords].empty?
    schools = {
        :pomona => params[:pomona] || false,
        :claremont_mckenna => params[:claremont_mckenna] || false,
        :harvey_mudd => params[:harvey_mudd] || false,
        :scripps => params[:scripps] || false,
        :pitzer => params[:pitzer] || false
    }
    schools.select! {|k,v| v}
    if schools.length > 0
      schools = schools.keys
    else
      schools = CourseMeetingDetail.campus.keys.map(&:to_sym)
    end

    # database queries
    matches_query = Course.order("number")
    matches_query = matches_query.where(number: number) if number
    # TODO: Turn back on search by department
    # if (department_code)
    #   matches_query = matches_query
    #     .joins(:departments)
    #     .where(:departments => {:code => department_code})
    # end

    # if (keywords)
    #   matches_query = matches_query.select {|course| keywords.any? {|keyword| course.name.downcase.include? keyword.downcase}}
    #   matches_query = matches_query.sort_by {|course| get_keyword_relevance(course, keywords)}
    # end
    
    # Using SQL rather than Ruby to filter by keywords
    if (keywords)
      keywords_query = keywords.map { |k| "%#{k.downcase}%" }
      matches_query = matches_query.where("LOWER(name) LIKE ANY ( array[?] )", keywords_query)
      matches_query = matches_query.order(Arel.sql("get_keyword_relevance(name, ARRAY[#{keywords_query.join(',')}])"))
    end

    # database response filtering
    if (schools)
      matches_query = matches_query.select {|course| schools.any? {|school| course.schools.any? {|s| s == school} rescue false}}
    end


    # server response
    @courses = matches_query.uniq
    respond_to do |format|
      format.html {render :json => matches.to_json, :status => :ok}
      format.json {render :json => matches.to_json, :status => :ok}
      format.js
    end
  end

  def search_instructor_reviews
    instructor_name = params[:instructor].strip unless params[:instructor].empty?

    matches_query = Instructor.order("id")

    if (instructor_name)
      instructor_name_query = "%#{instructor_name}%"

      matches_query = matches_query
        .where("name ILIKE ?", instructor_name_query)
    else
      matches_query = []
    end

    @instructors = matches_query.uniq
    respond_to do |format|
      format.html {render :json => matches.to_json, :status => :ok}
      format.json {render :json => matches.to_json, :status => :ok}
      format.js
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def review_params
    params
        .require(:course_review)
        .permit(:overall_rating, :challenge_rating, :total_cost, :inclusivity_rating, :work_per_week, :comments,
                :course_id, :instructor_id, :id)
  end

  def get_keyword_relevance(course, keywords)
    occurences = 0
    keywords.each do |keyword|
      occurences += course.name.downcase.scan(/(?=#{keyword})/).count
    end
    logger.info "#{course.name.downcase}, #{keywords}, #{occurences}"
    return 1.0/occurences
  end
end
