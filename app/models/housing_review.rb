class HousingReview < ApplicationRecord
  belongs_to :housing_room
  belongs_to :user, :optional => true

  validates :housing_room, presence: true
  has_many_attached :images
  validate :validate_image_size

  def written_at
    self.created_at.strftime("%B %Y")
  end

  private

  def validate_image_size
    images.each do |image|
      if image.byte_size > 5.megabytes
        errors.add(:images, "A file uploaded exceeds the maximum allowed size of 5MB.")
      end
    end
  end
end
