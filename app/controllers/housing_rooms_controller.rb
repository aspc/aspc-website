class HousingRoomsController < InheritedResources::Base

  def show_buildings
    @housing_buildings = HousingBuilding.all
  end

  def show_building_rooms
    building_id = params[:dorm_id]
    @housing_building = HousingBuilding.find(building_id)

    @housing_suites = @housing_building.housing_suites
    @housing_rooms = @housing_building.housing_rooms
  end

  def show
    room_id = params[:room_id]
    @housing_room = HousingRoom.find(room_id)
  end

end

