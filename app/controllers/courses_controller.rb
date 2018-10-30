class CoursesController < ApplicationController
  before_action :authenticate_user!

  def index
    @academic_terms = AcademicTerm.current_academic_year
    @departments = Department.all

    user_course_schedule = CourseSchedule.find_or_create_by(:user => current_user)
    @course_sections = user_course_schedule.course_sections
  end

  # TODO: Move to course schedule controller ?
  def add_course_section_to_schedule
    code_slug= params[:code_slug]
    @course_section = CourseSection.find_by(:code_slug => code_slug)

    @course_schedule = CourseSchedule.find_or_create_by(:user => current_user)
    if(@course_schedule.course_sections.none? { |section| section.code_slug == @course_section.code_slug })
      @course_schedule.course_sections << @course_section
      @course_schedule.save
    end

    respond_to do |format|
      format.js
    end
  end

  # TODO: Move to course schedule controller ?
  def remove_course_section_from_schedule
    @course_schedule = CourseSchedule.find_or_create_by(:user => current_user)

    code_slug= params[:code_slug]
    @course_section = CourseSection.find_by(:code_slug => code_slug)
    @course_schedule.course_sections.delete(@course_section)

    respond_to do |format|
      format.js
    end
  end

  # TODO: Move to course schedule controller ?
  def clear_course_sections_from_schedule
    @course_schedule = CourseSchedule.find_or_create_by(:user => current_user)
    @course_schedule.course_sections.delete(*@course_schedule.course_sections)

    respond_to do |format|
      format.js
    end
  end

  # TODO: Move to course schedule controller ?
  # This method is actually completely redundant,
  # but mas as well provide a placebo / verification
  def save_course_sections_to_schedule
    respond_to do |format|
      format.js { flash.now[:notice] = "Schedule saved successfully." }
    end
  end

  def search_course_sections
    if params[:academic_term].nil? || params[:academic_term].empty?
      return render :json => {error: "No academic term specified"}, :status => :bad_request
    end

    term_key = params[:academic_term].split.reverse.join(';')
    department_code = Department.find_by(:name => params[:department]).code unless params[:department].empty?
    instructor_name =  params[:instructor].strip unless params[:instructor].empty?
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
      schools = CourseMeetingDetail.campus.keys
    end

    days = {
        :monday => params[:monday] || false,
        :tuesday => params[:tuesday] || false,
        :wednesday => params[:wednesday] || false,
        :thursday => params[:thursday] || false,
        :friday => params[:friday] || false
    }
    days.select! {|k,v| v}

    matches_query = CourseSection
          .joins(:academic_term)
          .joins(:course => [:departments])
          .where(:academic_terms => {:key => term_key})

    if(instructor_name)
      matches_query = matches_query
          .joins(:instructors)
          .where(:instructors => {:name => instructor_name})
    end

    if(days.length > 0)
      matches_query = matches_query
          .joins(:course_meeting_details)
          .where(:course_meeting_details => days)
    end

    if(department_code)
      matches_query = matches_query
          .where(:courses => {:departments => {:code => department_code}})
    end

    if(number)
      matches_query = matches_query
          .where(:courses => {:number => number })
    end

    matches = matches_query.order("courses.number").all
    if(schools)
      matches = matches.select { |section| schools.any? { |campus| section.course_meeting_details.any? {  |detail| detail.campus == campus.to_s } } }
    end
    if(keywords)
      matches = matches.select { |section| keywords.any? { |keyword| section.course.name.include? keyword } }
    end

    @course_sections = matches
    respond_to do |format|
      format.html { render :json => matches.to_json, :status => :ok }
      format.json { render :json => matches.to_json, :status => :ok }
      format.js
    end
  end
end
