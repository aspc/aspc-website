class CoursesController < ApplicationController
  before_action :authenticate_user!

  def index
    @academic_terms = AcademicTerm.current_academic_year
    @departments = Department.all
    @course_meeting_details = CourseMeetingDetail.all

    user_course_schedule = CourseSchedule.find_or_create_by(:user => current_user)
    @course_sections = user_course_schedule.course_sections
  end

  def show
    @course = Course.find(params[:id])
  end

  def export_course_sections
    user_course_schedule = CourseSchedule.find_by(:user => current_user)
    course_sections = user_course_schedule.course_sections.includes(:course_meeting_details).where.not(course_meeting_details: {course_section_id: nil})
    academic_term = course_sections.first&.academic_term

    if !academic_term # Academic Term is decided by the courses on the schedule
      return redirect_to courses_path, :flash => {
          :notice => "Cannot export schedule",
          :notice_subtitle => "You haven't saved any courses to your schedule!",
          :notice_class => "is-danger",
      }
    end

    calendar = Icalendar::Calendar.new
    calendar.version = "2.0"
    filename = "#{academic_term.session.parameterize}-#{academic_term.year}-courses.ics"

    case academic_term.key
    when "2019;SP"
      term_start = DateTime.new(2019, 1, 22, 8, 10, 0)
      term_end = DateTime.new(2019, 5, 8, 22, 0, 0)
    when "2019;FA"
      term_start = DateTime.new(2019, 9, 3, 8, 10, 0)
      term_end = DateTime.new(2019, 12, 11, 22, 0, 0)
    else
      return redirect_to courses_path # This is temporary and MUST be made into something more permanent than hardcoding
    end

    (term_start..term_end).each do |date|
       course_sections.each do |course_section|
        course_section.course_meeting_details.each do |detail|
          case date.strftime("%w")
          when "1"
            if detail.monday
              new_calendar_event(calendar, date, course_section, detail)
            end
          when "2"
            if detail.tuesday
              new_calendar_event(calendar, date, course_section, detail)
            end
          when "3"
            if detail.wednesday
              new_calendar_event(calendar, date, course_section, detail)
            end
          when "4"
            if detail.thursday
              new_calendar_event(calendar, date, course_section, detail)
            end
          when "5"
            if detail.friday
              new_calendar_event(calendar, date, course_section, detail)
            end
          end
        end
      end
    end

    send_data calendar.to_ical, type: "text/calendar", disposition: "attachment", filename: filename
  end

# TODO: Move to course schedule controller ?
  def add_course_section_to_schedule
    section_id = params[:section_id]
    @course_section = CourseSection.find_by(:id => section_id)

    @course_schedule = CourseSchedule.find_or_create_by(:user => current_user)
    if (@course_schedule.course_sections.none? {|section| section.code_slug == @course_section.code_slug})
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

    section_id = params[:section_id]
    @course_section = CourseSection.find_by(:id => section_id)
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
      format.js {flash.now[:notice] = "Schedule saved successfully."}
    end
  end

# TODO: Refactor this - break it up into manageable components
# Possibly separate search into a separate module entirely (as it is used similarly in course reviews)
  def search_course_sections
    if params[:academic_term].nil? || params[:academic_term].empty?
      return render :json => {error: "No academic term specified"}, :status => :bad_request
    end

    term_key = params[:academic_term].split.reverse.join(';')
    department_code = Department.find_by(:name => params[:department]).code unless params[:department].empty?
    instructor_name = params[:instructor].strip unless params[:instructor].empty?
    number = params[:number].to_i rescue nil unless params[:number].empty?
    keywords = params[:keywords].split rescue nil unless params[:keywords].empty?


    # Remove time filter TODO: re-enable
    # start_hour = params["start_time(4i)"].to_i rescue nil unless params["start_time(4i)"].empty?
    # start_minute = params["start_time(5i)"].to_i rescue nil unless params["start_time(5i)"].empty?
    # end_hour = params["end_time(4i)"].to_i rescue nil unless params["end_time(4i)"].empty?
    # end_minute = params["end_time(5i)"].to_i rescue nil unless params["end_time(5i)"].empty?

    # Remove time filter TODO: re-enable
    # consider_time = false
    # if not start_hour.nil?  # if user specifies start time
    #   start_time = Time.new(1970, 1, 1, start_hour, start_minute)
    #
    #   if end_hour.nil? then end_hour = 23 end   # if user doesn't specify end time, set default value to display all classes after start time
    #
    #   end_time = Time.new(1970, 1, 1, end_hour, end_minute)
    #   consider_time = true
    # elsif not end_hour.nil?   # if user only specifies end time but not start time
    #   end_time = Time.new(1970, 1, 1, end_hour, end_minute)
    #
    #   if start_hour.nil? then start_hour = 0 end   # double check that user did not set start time, set default value to display all classes before end time
    #
    #   start_time = Time.new(1970, 1, 1, start_hour, start_minute)
    #   consider_time = true
    # end

    # times are given in PST/PDT, but database auto-converts times to UTC before performing query
    # times need to be shifted back 7/8 hours by converting from UTC to PST/PDT
    # start_time = ActiveSupport::TimeZone.new('America/Los_Angeles').utc_to_local(start_time) if start_time
    # end_time = ActiveSupport::TimeZone.new('America/Los_Angeles').utc_to_local(end_time) if end_time

    # Gets results from individual checkboxes with corresponding symbols
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

    # Gets results from individual checkboxes with corresponding symbols
    days = {
        :monday => params[:monday] || false,
        :tuesday => params[:tuesday] || false,
        :wednesday => params[:wednesday] || false,
        :thursday => params[:thursday] || false,
        :friday => params[:friday] || false
    }
    days.select! {|k, v| v}

    matches_query = CourseSection
                        .joins(:academic_term)
                        .joins(:course => [:departments])
                        .where(:academic_terms => {:key => term_key})

    if (days.length > 0)
      matches_query = matches_query
                          .joins(:course_meeting_details)
                          .where(:course_meeting_details => days)
    end

    # Remove time filter TODO: re-enable
    # if (consider_time)
    #   matches_query = matches_query
    #                       .joins(:course_meeting_details)
    #                       .where(:course_meeting_details => {:start_time => start_time..end_time})
    #                       .where(:course_meeting_details => {:end_time => start_time..end_time})
    # end

    if (department_code)
      matches_query = matches_query
                          .where(:courses => {:departments => {:code => department_code}})
    end

    if (number)
      matches_query = matches_query
                          .where(:courses => {:number => number})
    end

    matches = matches_query.order("courses.number").all

    if (schools)
      matches = matches.select {|section| schools.any? {|campus| section.course_meeting_details.any? {|detail| detail.campus == campus.to_s}}}
    end
    if (instructor_name)
      matches = matches.select {|section| section.instructors.any? {|instructor| instructor.name.downcase.include? instructor_name.downcase}}
    end
    if (keywords)
      matches = matches.select {|section| keywords.any? {|keyword| section.course.name.downcase.include? keyword.downcase}}
      matches = matches.sort_by {|section| get_keyword_relevance(section, keywords)}
    end

    matches = matches.uniq

    @course_sections = matches
    respond_to do |format|
      format.html {render :json => matches.to_json, :status => :ok}
      format.json {render :json => matches.to_json, :status => :ok}
      format.js
    end
  end

  private

  def new_calendar_event(calendar, date, course_section, detail)
    event = calendar.event
    event.summary = "#{course_section.course.code} #{course_section.course.name}"
    start_time = DateTime.new(date.year, date.month, date.day, detail.start_time.hour, detail.start_time.min, 0)
    end_time = DateTime.new(date.year, date.month, date.day, detail.end_time.hour, detail.end_time.min, 0)
    event.dtstart = Icalendar::Values::DateTime.new(start_time)
    event.dtend = Icalendar::Values::DateTime.new(end_time)
    event.description = course_section.description
    event.location = detail.location
  end

  # counts the number of total occurences of each keyword in the course name
  # lower number = higher rank, so the counted numbers need to be reversed
  # 1.0/occurences flips the order
  def get_keyword_relevance(section, keywords)
    occurences = 0
    keywords.each do |keyword|
      occurences += section.course.name.downcase.scan(/(?=#{keyword})/).count
    end
    logger.info "#{section.course.name.downcase}, #{keywords}, #{occurences}"
    return 1.0/occurences
  end

end
