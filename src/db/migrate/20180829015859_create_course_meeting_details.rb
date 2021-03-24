class CreateCourseMeetingDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :course_meeting_details do |t|
      t.time :start_time
      t.time :end_time

      t.boolean :monday, :null => false, :default => false
      t.boolean :tuesday, :null => false, :default => false
      t.boolean :wednesday, :null => false, :default => false
      t.boolean :thursday, :null => false, :default => false
      t.boolean :friday, :null => false, :default => false

      t.integer :campus, :null => false, :default => 0
      t.string :location

      t.timestamps
    end
  end
end
