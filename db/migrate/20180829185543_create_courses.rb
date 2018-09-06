class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :code, :null => false, unique: true
      t.string :code_slug, :null => false, unique: true
      t.integer :number, :null => false, default: 0
      t.text :name, :null => false

      t.timestamps
    end

    add_index(:courses, :code, :unique => true)
    add_index(:courses, :code_slug, :unique => true)
  end
end
