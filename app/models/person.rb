class Person < ApplicationRecord
  enum role: [:senator, :staff, :bot]
  has_one_attached :image
end
