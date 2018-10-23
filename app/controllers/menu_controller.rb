class MenuController < ApplicationController
  def index
    @meal_type = "lunch"
    @day = Date.today.wday
  end

  def show
    @meal_type = params[:meal_type]
    @day = params[:day]

    respond_to do |format|
      format.js
    end
  end
end
