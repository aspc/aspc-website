class InstructorsController < ApplicationController
  def show
    @instructor = Instructor.find(params[:id])
  end
end
