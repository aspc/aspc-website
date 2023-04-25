class CourseReview < ApplicationRecord
  default_scope { order(:created_at => :desc) }

  belongs_to :course
  belongs_to :instructor
  belongs_to :user, :optional => true

  validates :course, :presence => true
  validates :overall_rating, :presence => true
  validates :inclusivity_rating, :presence => true
  validates :challenge_rating, :presence => true
  validates :work_per_week, :presence => true
  validates :total_cost, :presence => true

  accepts_nested_attributes_for :course
  accepts_nested_attributes_for :instructor

  def written_at
    self.created_at.strftime("%B %Y")
  end
end
