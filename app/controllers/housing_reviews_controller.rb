class HousingReviewsController < InheritedResources::Base
  before_action :set_housing_room
  before_action :authenticate_user!, only: [:create, :new, :destroy]

  def index
    @housing_reviews = @housing_room.housing_reviews

    @average_overall_rating = get_average_rating(@housing_reviews.map {|r| r.overall_rating})
    @average_quiet_rating = get_average_rating(@housing_reviews.map {|r| r.quiet_rating})
    @average_temperature_rating = get_average_rating(@housing_reviews.map {|r| r.temperature_rating})
    @average_layout_rating = get_average_rating(@housing_reviews.map {|r| r.layout_rating})

    @users = User.all
  end

  def destroy
    @housing_review = @housing_room.housing_reviews.find_by(:id => params[:id])
    if current_user.id == @housing_review.user_id
      @housing_review.destroy
    end

    redirect_to housing_reviews_path, notice: "Housing review was successfully deleted."
  end

  private

    def set_housing_room
      room_id = params[:room_id]
      @housing_room = HousingRoom.find_by(id: room_id)
    end

    def housing_review_params
      whitelisted = params.require(:housing_review).permit(:overall_rating, :quiet_rating, :layout_rating, :temperature_rating, :comments, :housing_room, :user_id)

      if whitelisted[:housing_room].present?
        whitelisted[:housing_room] = HousingRoom.find_by(:id => whitelisted[:housing_room])
      end

      whitelisted
    end

    def get_average_rating(ratings)
      ratings = ratings.reject{|r| r == 0 || r == nil}
      return (ratings.length == 0 ? 0 : ratings.inject(0, :+) / ratings.length)
    end
end