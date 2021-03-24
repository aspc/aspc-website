class Course < ApplicationRecord
  has_and_belongs_to_many :departments
  has_many :course_sections
  has_many :course_reviews

  accepts_nested_attributes_for :departments

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

  # collect all instructors that have ever taught a section of this course
  def instructors
    self.course_sections
        &.collect{ |section| section.instructors }
        .reduce(:+)
        .uniq
  end

  # collect all the schools that this course is taught at
  def schools
    self.course_sections
        &.collect{ |section| section.schools }
        .reduce(:+)
        .uniq
  end
end
