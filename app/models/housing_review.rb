class HousingReview < ApplicationRecord
  belongs_to :housing_room
  belongs_to :user, :optional => true

  validates :housing_room, presence: true
  has_one_attached :image

  def written_at
    self.created_at.strftime("%B %Y")
  end
end
