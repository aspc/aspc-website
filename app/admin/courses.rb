ActiveAdmin.register Course do
  permit_params :code, :code_slug, :number, :name, department_ids: []

  sidebar "Nested Attributes", only: [:show, :edit] do
    ul do
      li link_to "Course Sections",    admin_course_course_sections_path(resource)
      li link_to "Departments", admin_departments_path
    end
  end

  form do |f|
    f.inputs

    f.inputs do
      f.input :department_ids, as: :select, input_html: { multiple: true }, collection: Department.all
    end

    f.actions
  end
end

ActiveAdmin.register CourseSection do
  belongs_to :course
  menu false

  permit_params :code, :code_slug, :description, :credit, :academic_term_id,
                instructor_ids: [],
                course_meeting_details_attributes: [:id, :start_time, :end_time, :monday, :tuesday, :wednesday, :thursday, :friday, :campus, :location]

  sidebar "Nested Attributes", only: [:show, :edit] do
    ul do
      li link_to "Course Meeting Times", admin_course_section_course_meeting_details_path(resource)
      li link_to "Instructors", admin_instructors_path
    end
  end

  form do |f|
    f.inputs

    f.inputs do
      f.input :instructor_ids, as: :select, input_html: { multiple: true }, collection: Instructor.all
    end

    f.inputs do
      f.has_many :course_meeting_details, heading: 'Meeting Times' do |d|
        d.input :start_time
        d.input :end_time
        d.input :campus

        d.input :monday
        d.input :tuesday
        d.input :wednesday
        d.input :thursday
        d.input :friday
      end
    end

    f.actions
  end
end

ActiveAdmin.register CourseMeetingDetail do
  belongs_to :course_section

  permit_params :start_time, :end_time, :monday, :tuesday, :wednesday, :thursday, :friday, :campus, :location
end