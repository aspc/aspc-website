class InstructorsController < ApplicationController
  before_action :authenticate_user!

  def show
    @instructor = Instructor.find(params[:id])
  end

  def add_instructor_review
    @instructor = Instructor.find(params[:id])
  end
end