class Announcement < ApplicationRecord
  scope :priority_order, -> {order(priority: :asc)}
  has_one_attached :background_image
end
