class AddCourseReviewCost < ActiveRecord::Migration[5.2]
    def change
      add_column :course_reviews, :total_cost, :decimal
    end
  end