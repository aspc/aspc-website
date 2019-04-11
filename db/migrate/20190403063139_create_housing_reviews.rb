class CreateHousingReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :housing_reviews do |t|
      t.decimal :overall_rating, :null => false, :default => 0
      t.decimal :quiet_rating, :null => false, :default => 0
      t.decimal :layout_rating, :null => false, :default => 0
      t.decimal :temperature_rating, :null => false, :default => 0

      t.text :comments
      t.timestamps
    end

    add_reference :housing_reviews, :housing_room, index: true
    add_reference :housing_reviews, :user, index: true
  end
end
