class CourseSection < ApplicationRecord
  has_and_belongs_to_many :instructors
  has_many :course_meeting_details
  belongs_to :academic_term
  belongs_to :course

  enum campus: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
end
