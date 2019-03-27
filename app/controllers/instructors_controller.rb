class InstructorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @departments = Department.all
  end

  def show
    @instructor = Instructor.find(params[:id])
  end

  def add_instructor_review
    @instructor = Instructor.find(params[:id])
  end

  def search
    instructor_name = params[:instructor].strip unless params[:instructor].empty?

    matches_query = Instructor

    matches = matches_query.order("id").all

    if (instructor_name)
      matches = matches.select {|instructor| instructor.name.downcase.include? instructor_name.downcase}
    end

    matches = matches.uniq

    @instructors = matches
    respond_to do |format|
      format.html {render :json => matches.to_json, :status => :ok}
      format.json {render :json => matches.to_json, :status => :ok}
      format.js
    end
  end
end