class HousingRoomsController < InheritedResources::Base

  def show_buildings
    @housing_buildings = HousingBuilding.all
  end

  def show_building_rooms
    building_id = params[:dorm_id]
    @housing_building = HousingBuilding.find(building_id)

    @housing_suites = @housing_building.housing_suites
    @housing_rooms = @housing_building.housing_rooms

    @housing_reviews = HousingReview.all
  end

  def show
    room_id = params[:room_id]
    @housing_room = HousingRoom.find(room_id)
  end

  def get_average_rating(reviews)
    ratings = reviews.map {|r| r.overall_rating}
    return (ratings.length == 0 ? 0 : ratings.reject{ |r| r == 0 }.inject(0, :+) / ratings.length)
  end
  helper_method :get_average_rating

end