class Person < ApplicationRecord
  enum role: [:senator, :staff, :board]
  scope :priority_order, -> {order(priority: :asc)}
  has_one_attached :image
end
