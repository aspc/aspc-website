class HousingSuite < ApplicationRecord
  belongs_to :housing_building
  has_many :housing_rooms

  enum suite_type: { unkown: 0, three_person: 3, four_person: 4, five_person: 5, six_person: 6 }
end
