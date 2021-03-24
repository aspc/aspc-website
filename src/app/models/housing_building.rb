class HousingBuilding < ApplicationRecord
  has_many :housing_rooms
  has_many :housing_suites

  has_one_attached :image

  validates :name, :presence => true, :allow_blank => false, :uniqueness => true
end
