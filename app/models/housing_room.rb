class HousingRoom < ApplicationRecord
  belongs_to :housing_suite, :optional => true
  belongs_to :housing_building
  has_many :housing_reviews

  validates :housing_building_id, :presence => true, :allow_blank => :false
  validates :room_number, :presence => true, :allow_blank => :false
  validates_uniqueness_of :room_number, :scope => [:housing_building_id]

  enum occupancy_type: { unknown_occupancy: 0, single: 1, double: 2, two_room_double: 3, two_room_triple: 4 }
  enum closet_type: { unknown_closet: 0, free_standing: 1, walk_in: 2, bump_out: 3 }
  enum bathroom_type: { unknown_bathroom: 0, shared_hall: 1, shared_two_person: 2, unshared: 3 }

  def room_name
    "#{self.housing_building.name} #{self.room_number}"
  end

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
