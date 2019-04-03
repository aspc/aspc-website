class HousingReviewsController < InheritedResources::Base

  private

    def housing_review_params
      params.require(:housing_review).permit(:new, :create, :show, :index, :quiet_rating, :layout_rating, :temperature_rating, :comments)
    end
end

