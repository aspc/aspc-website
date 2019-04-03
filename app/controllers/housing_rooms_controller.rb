class HousingRoomsController < InheritedResources::Base

  def show
    room_id = params[:room_id]
    @housing_room = HousingRoom.find(room_id)
  end

end

