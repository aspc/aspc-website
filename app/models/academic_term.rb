class AcademicTerm < ApplicationRecord

  ##
  # Returns the two latest semesters

  scope :current_academic_year, -> { order(:year => :desc).order(:session => :asc).first(2) }
end
