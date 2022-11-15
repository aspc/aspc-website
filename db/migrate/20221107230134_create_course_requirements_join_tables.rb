class CreateCourseRequirementsJoinTables < ActiveRecord::Migration[5.2]
  def change
    create_join_table :courses, :requirements do |t|
      t.index [:course_id, :requirement_id]
      t.index [:requirement_id, :course_id]
    end
  end
end
