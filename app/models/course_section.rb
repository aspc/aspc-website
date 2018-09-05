class CourseSection < ApplicationRecord
  has_and_belongs_to_many :instructors
  has_many :course_meeting_details
  belongs_to :academic_term
  belongs_to :course

  def has_meeting_time?(course_meeting_detail)
    return self.course_meeting_details.any? { | detail | course_meeting_detail == detail }
  end
end
