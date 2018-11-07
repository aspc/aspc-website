class Course < ApplicationRecord
  has_and_belongs_to_many :departments
  has_many :course_sections
  has_many :course_reviews

  accepts_nested_attributes_for :departments

  def overall_rating
    self.course_reviews&.average(:overall_rating) || 0
  end
end
