class Person < ApplicationRecord
  enum role: [:senator, :staff]
  has_one_attached :image
end
