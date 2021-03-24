class CourseSchedule < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :course_sections
end
