class HousingBuilding < ApplicationRecord
  has_many :housing_rooms
  has_many :housing_suites

  validates :name, :presence => true, :allow_blank => false, :uniqueness => true
end
