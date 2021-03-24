class HousingReview < ApplicationRecord
  belongs_to :housing_room
  belongs_to :user, :optional => true

  validates :housing_room, presence: true

  def written_at
    self.created_at.strftime("%B %Y")
  end
end
