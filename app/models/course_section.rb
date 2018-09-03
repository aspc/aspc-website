class CourseSection < ApplicationRecord
  has_and_belongs_to_many :instructors
  has_many :course_meeting_details
  belongs_to :academic_term
  belongs_to :course
end
