class HousingBuilding < ApplicationRecord
  has_many :housing_rooms
  has_many :housing_suites

  has_one_attached :image1
  has_one_attached :image2
  has_one_attached :image3
  has_one_attached :image4
  has_one_attached :image5
  has_one_attached :floor_plans


  validates :name, :presence => true, :allow_blank => true, :uniqueness => false
end
