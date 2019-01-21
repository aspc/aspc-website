class Person < ApplicationRecord
  enum role: [:senator, :staff, :board]
  has_one_attached :image
end
