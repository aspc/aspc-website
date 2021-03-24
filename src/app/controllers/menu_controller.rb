class MenuController < ApplicationController
  def index
	@day = Date.today.wday

	require "tzinfo"

	# get current hour in local time, accounting for daylight savings
	timezone_name = "US/Pacific"
	timezone = TZInfo::Timezone.get(timezone_name)
	offset_in_hours = timezone.current_period.utc_total_offset / 60 / 60
	offset = "%+.2d:00" % offset_in_hours
	hour = Time.now.utc.getlocal(offset).hour

	if @day == 0 or @day == 6
		if hour < 14
			@meal_type = "brunch"
		else
			@meal_type = "dinner"
		end
	else
		if hour < 10
			@meal_type = "breakfast"
		elsif hour < 14
			@meal_type = "lunch"
		else
			@meal_type = "dinner"
		end
	end
  end

  def show
    @meal_type = params[:meal_type]
    @day = params[:day]

    respond_to do |format|
      format.js
    end
  end
end
