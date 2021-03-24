class Instructor < ApplicationRecord
  has_many :course_reviews
  has_and_belongs_to_many :course_sections

  def overall_rating
    self.course_reviews&.average(:overall_rating)&.round(1, :truncate) || 0
  end

  def inclusivity_rating
    self.course_reviews&.average(:inclusivity_rating)&.round(1, :truncate) || 0
  end

  def challenge_rating
    self.course_reviews&.average(:challenge_rating)&.round(1, :truncate) || 0
  end

  def work_per_week
    self.course_reviews&.average(:work_per_week)&.round(1, :truncate) || 0
  end

  def school
    self.course_sections
        &.first
        &.schools
        &.first
  end

  def courses
    self.course_sections
        &.collect{| section| section.course }
        &.uniq
  end
end
