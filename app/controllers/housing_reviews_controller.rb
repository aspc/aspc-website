class HousingReviewsController < InheritedResources::Base
  before_action :set_housing_room

  def index
    @housing_reviews = @housing_room.housing_reviews
  end

  private

    def set_housing_room
      room_id = params[:room_id]
      @housing_room = HousingRoom.find(room_id)
    end

    def housing_review_params
      whitelisted = params.require(:housing_review).permit(:overall_rating, :quiet_rating, :layout_rating, :temperature_rating, :comments, :housing_room)

      if whitelisted[:housing_room].present?
        whitelisted[:housing_room] = HousingRoom.find_by(:id => whitelisted[:housing_room])
      end

      whitelisted
    end
end

