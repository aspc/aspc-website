class HousingRoom < ApplicationRecord
  belongs_to :housing_suite, :optional => true

  enum occupancy_type: { unknown: 0, single: 1, double: 2, two_room_double: 3, two_room_triple: 4 }
  enum closet_type: { unknown: 0, free_standing: 1, walk_in: 2, bump_out: 3 }
  enum bathroom_type: { unknown: 0, shared_hall: 1, shared_two_person: 2, private: 3 }

end
