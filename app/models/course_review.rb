class CourseReview < ApplicationRecord
  belongs_to :course
  belongs_to :instructor

  accepts_nested_attributes_for :course
  accepts_nested_attributes_for :instructor
end
