class CourseReview < ApplicationRecord
  default_scope { order(:created_at => :desc) }

  belongs_to :course
  belongs_to :instructor

  accepts_nested_attributes_for :course
  accepts_nested_attributes_for :instructor

  def written_at
    self.created_at.strftime("%B %Y")
  end
end
