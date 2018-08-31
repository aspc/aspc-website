class CoursesController < ApplicationController
  def index
    @academic_terms = AcademicTerm.all
    @departments = Department.all
  end
end
