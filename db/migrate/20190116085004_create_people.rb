class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :position
      t.int :role
      t.string :email
      t.text :biography

      t.timestamps
    end
  end
end
