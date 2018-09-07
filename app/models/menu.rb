class Menu < ApplicationRecord
  has_many :menu_items

  enum dining_hall: [ :frank, :frary, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
  enum day: [ :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday ]
  enum meal_type: [ :breakfast, :lunch, :dinner, :brunch ]
end
