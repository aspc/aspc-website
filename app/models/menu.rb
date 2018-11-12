class Menu < ApplicationRecord
  has_many :menu_items

  enum dining_hall: [ :frank, :frary, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer, :oldenborg ]
  enum day: [ :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday ]
  enum meal_type: [ :breakfast, :lunch, :dinner, :brunch ]

  def self.for_day_and_meal_type(day, meal_type)
    Menu.where(:meal_type => meal_type).select {|x| x.day == day}.group_by(&:dining_hall)
  end
end
