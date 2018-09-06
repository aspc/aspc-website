class CreateCourseJoinTables < ActiveRecord::Migration[5.2]
  def change
    create_join_table :courses, :departments do |t|
      t.index :course_id
      t.index :department_id
    end

    create_join_table :course_sections, :instructors do |t|
      t.index :course_section_id
      t.index :instructor_id
    end
  end
end
