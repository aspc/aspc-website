class CreateCourseSections < ActiveRecord::Migration[5.2]
  def change
    create_table :course_sections do |t|
      t.string :code, :null => false
      t.string :code_slug, :null => false
      t.text :description
      t.decimal :credit, :null => false, :default => true
      t.integer :perms
      t.integer :spots
      t.boolean :filled
      t.boolean :fee

      t.timestamps
    end
  end
end
