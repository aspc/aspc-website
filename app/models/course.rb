class Course < ApplicationRecord
  has_and_belongs_to_many :departments
  has_many :course_sections
end
