class HousingRoom < ApplicationRecord
  belongs_to :housing_suite, :optional => true
  has_many :housing_reviews

  enum occupancy_type: { unknown: 0, single: 1, double: 2, two_room_double: 3, two_room_triple: 4 }
  enum closet_type: { unknown: 0, free_standing: 1, walk_in: 2, bump_out: 3 }
  enum bathroom_type: { unknown: 0, shared_hall: 1, shared_two_person: 2, private: 3 }

  def overall_rating
    self.housing_reviews&.average(:overall_rating)&.round(2, :truncate) || 0
  end

  def layout_rating
    self.housing_reviews&.average(:layout_rating)&.round(2, :truncate) || 0
  end

  def quiet_rating
    self.housing_reviews&.average(:quiet_rating)&.round(2, :truncate) || 0
  end

  def temperature_rating
    self.housing_reviews&.average(:temperature_rating)&.round(2, :truncate) || 0
  end
end
