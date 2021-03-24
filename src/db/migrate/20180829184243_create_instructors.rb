class CreateInstructors < ActiveRecord::Migration[5.2]
  def change
    create_table :instructors do |t|
      t.string :name, :null => false
      t.decimal :inclusivity_rating
      t.decimal :competency_rating
      t.decimal :challenge_rating

      t.timestamps
    end
  end
end
