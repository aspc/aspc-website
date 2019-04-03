class HousingReview < ApplicationRecord
  belongs_to :housing_room
  belongs_to :user, :optional => true
end
