class CreateCourseReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :course_reviews do |t|
      t.decimal :overall_rating
      t.decimal :challenge_rating
      t.decimal :inclusivity_rating
      t.decimal :work_per_week
      t.decimal :total_cost
      t.text :comments

      t.timestamps
    end

    add_reference :course_reviews, :course, index: true
    add_reference :course_reviews, :instructor, index: true
  end
end
