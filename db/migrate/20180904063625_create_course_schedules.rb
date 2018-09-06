class CreateCourseSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :course_schedules do |t|
      t.timestamps
    end

    create_join_table :course_schedules, :course_sections do |t|
      t.index :course_schedule_id
      t.index :course_section_id
    end

    add_reference :course_schedules, :user, index: true
  end
end
