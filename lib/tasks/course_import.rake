require 'httparty'

namespace :course_import do
  desc "Imports Academic Terms"
  task :academic_terms => :environment do
    api_url = Rails.application.credentials[:course_api][:url]
    terms_url = [api_url, 'terms'].join('/')

    Rails.logger.info "Fetching terms from #{terms_url}"
    terms = HTTParty.get(terms_url, :format => :json).parsed_response

    terms.each do |term_info|
      if term_info['SubSession'] == ''
          key = term_info['Key']

          term = AcademicTerm.find_by_key(key)
          if(term.nil?)
            Rails.logger.info "Creating new Academic Term for key: #{key}"
            term = AcademicTerm.new({key: key})
          else
            Rails.logger.info "Found existing Academic Term for key: #{key}"
          end


        term.year = term_info['Year']
        term.session = term_info['Session']

        term.save
        Rails.logger.info "Successfully updated Academic Term: #{term}"
      else
        Rails.logger.info "Skipping Academic Term for key: #{key}"
      end
    end
  end

  desc "Imports Departments"
  task :departments => :environment do
    api_url = Rails.application.credentials[:course_api][:url]
    departments_url = [api_url, 'courseareas'].join('/')

    Rails.logger.info "Fetching departments from #{departments_url}"
    departments = HTTParty.get(departments_url, :format => :json).parsed_response

    departments.each do |department_info|
      code = department_info['Code']

      next unless code[0] =~ /[[:alpha:]]/ # If it starts with a number, then it's not a Department

      department = Department.find_by_code(code)
      if(department.nil?)
        Rails.logger.info "Creating new Department for code: #{code}"
        department = Department.new({code: code})
      else
        Rails.logger.info "Found existing Department for code: #{code}"
      end

      department.name = department_info['Description']

      department.save
      Rails.logger.info "Successfully updated Department: #{department}"
    end
  end

  desc "Imports Courses"
  task :courses => :environment do
    api_url = Rails.application.credentials[:course_api][:url]

    terms =  AcademicTerm.current_academic_year

    terms.each do |term|
      Rails.logger.info "Fetching courses for Academic Term #{term.key}"

      departments = Department.all
      departments.each do |department|
        Rails.logger.info "Fetching courses for Department #{department.code} in Academic Term #{term.key}"

        courses_url = [api_url, 'courses', term.key, department.code].join('/')
        courses = HTTParty.get(courses_url, :format => :json).parsed_response rescue nil

        next if courses.nil?

        courses.each do |course_info|
          next if course_info['CourseCode'].nil?

          # Create or update a course
          course_code = course_info['CourseCode'][0...-3] # e.g. 'ANTH088 PZ' instead of 'ANTH088 PZ-01'
          course = Course.find_by(
              :code => course_code,
              :code_slug => course_code.parameterize.upcase
          )

          if(course.nil?)
            Rails.logger.info "Creating new Course for code: #{course_code}"
            course = Course.new({:code => course_code, :code_slug => course_code.parameterize.upcase})
          else
            Rails.logger.info "Found existing Course for code: #{course_code}"
          end

          course.name = course_info['Name'] || ''
          course.number = course_code.chars.select { |c| Float(c) != nil rescue false }.join.to_i
          course.departments << department unless course.departments.any? { |d| d.code == department.code }

          course.save
          Rails.logger.info "Successfully updated Course: #{course.code}"

          # Create or update a course section
          section_code = course_info['CourseCode'] # e.g. 'ANTH088 PZ-01' instead of 'ANTH088 PZ'
          section = CourseSection.find_by(
             :academic_term_id => term.id,
             :course_id => course.id,
             :code => section_code,
             :code_slug => section_code.parameterize.upcase
          )
          if(section.nil?)
            Rails.logger.info "Creating new Course Section for code: #{section_code}"
            puts "New section #{section_code} for course #{course_code}"
            section = CourseSection.new({:code => section_code, :code_slug => section_code.parameterize.upcase})
          else
            puts "Found section #{section_code} for course #{course_code}"
            Rails.logger.info "Found existing Course Section for code: #{section_code}"
          end

          section.description = course_info['Description'] || ''
          section.credit = Float(course_info['Credits']) rescue 1.00
          section.fee = section.description =~ /[Ff]ee:\s+\$([\d\.]+)/ # RegEx to determine whether there's a fee
          section.academic_term = term
          section.course = course

          # Add instructors for course section
          instructors = course_info['Instructors']
          instructors.each do |instructor_info|
            instructor_name = instructor_info['Name']
            instructor = Instructor.find_by_name(instructor_name)
            if(instructor.nil?)
              Rails.logger.info "Creating new Instructor #{instructor_name} for Course Section #{section.code}"
              instructor = Instructor.new({:name => instructor_name})
            else
              Rails.logger.info "Found existing Instructor #{instructor_name} for Course Section #{section.code}"
            end
            section.instructors << instructor unless section.instructors.any? { |i| i.name == instructor.name }
          end unless instructors.nil?

          # Add meeting times for course section
          section.course_meeting_details.destroy_all

          meetings = course_info['Schedules']
          meetings.each do |meeting_info|
            if meeting_info['Weekdays']
              parsed_course_meeting_info = _parse_meeting_data(meeting_info)
              next if parsed_course_meeting_info.nil?

              # If parsing campus failed, try parsing via course code slug
              if parsed_course_meeting_info[:campus] == :unknown
                campus_lookup = {
                    "PO" => :pomona,
                    "CM" => :claremont_mckenna,
                    "HM" => :harvey_mudd,
                    "SC" => :scripps,
                    "PZ" => :pitzer
                }
                campus_code = section.course.code[-2..-1]
                parsed_course_meeting_info[:campus] = campus_lookup[campus_code] || :unknown
              end

              course_meeting_detail = CourseMeetingDetail.new(parsed_course_meeting_info)

              if !section.has_meeting_time? course_meeting_detail
                section.course_meeting_details << course_meeting_detail
              end
            end
          end unless meetings.nil?

          section.save
          Rails.logger.info "Successfully updated Course Section #{section.code} for Course #{course.code}"
        end
      end
    end
  end

  def _parse_meeting_data(meeting_info)
    # Parse Weekdays
    weekdays = meeting_info['Weekdays']
    monday = weekdays.include?('M')
    tuesday = weekdays.include?('T')
    wednesday = weekdays.include?('W')
    thursday = weekdays.include?('R')
    friday = weekdays.include?('F')

    # Parse begin/end times
    begin
      meeting_time_raw = meeting_info['MeetTime']
      start_time_raw, start_pm, end_time_raw, end_pm = meeting_time_raw.scan(/(\d+:\d+)(AM|PM)?-(\d+:\d+)(AM|PM)./)[0]

      end_pm = end_pm == 'PM'
      start_pm = start_pm.nil? ? end_pm : start_pm == 'PM'

      start_hour, start_minute = start_time_raw.split(':').map(&:to_i)
      end_hour, end_minute = end_time_raw.split(':').map(&:to_i)

      end_hour += 12 if end_pm && end_hour < 12
      start_hour += 12 if start_pm && start_hour < 12

      start_time = DateTime.new(1970, 01, 01, start_hour, start_minute).utc
      end_time = DateTime.new(1970, 01, 01, end_hour, end_minute).utc
    rescue
      Rails.logger.error "Error parsing meeting time, skipping time parsing..."
    ensure
      start_time ||= nil
      end_time ||= nil
    end

    # Parse campus
    begin
      campus_code = meeting_info['Campus'].split(' ')[0]
      campus_lookup = {
          "PO" => :pomona,
          "CM" => :claremont_mckenna,
          "HM" => :harvey_mudd,
          "SC" => :scripps,
          "PZ" => :pitzer
      }

      campus = campus_lookup[campus_code]
    rescue
      Rails.logger.error "Error parsing campus, skipping campus parsing..."
    ensure
      campus ||= :unknown
    end

    # TODO: Location
    return {
        :monday => monday,
        :tuesday => tuesday,
        :wednesday => wednesday,
        :thursday => thursday,
        :friday => friday,
        :start_time => start_time,
        :end_time => end_time,
        :campus => campus
    }
  end
end