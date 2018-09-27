class MenuController < ApplicationController
  def index
    @dining_hall = "frary"
    @day = Date.today.wday
  end

  def show
    @dining_hall = params[:dining_hall]
    @day = params[:day] || "sunday"

    respond_to do |format|
      format.js
    end
  end
end
