class CreateCourseAssociations < ActiveRecord::Migration[5.2]
  def change
    add_reference :course_sections, :course, index: true
    add_reference :course_sections, :academic_term, index: true
    add_reference :course_meeting_details, :course_section, index: true
  end
end
