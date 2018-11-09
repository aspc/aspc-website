class Instructor < ApplicationRecord
  has_many :course_reviews

  def overall_rating
    self.course_reviews&.average(:overall_rating) || 0
  end

  def inclusivity_rating
    self.course_reviews&.average(:inclusivity_rating) || 0
  end

  def challenge_rating
    self.course_reviews&.average(:challenge_rating) || 0
  end

  def work_per_week
    self.course_reviews&.average(:work_per_week).round(2, :truncate) || 0
  end
end
