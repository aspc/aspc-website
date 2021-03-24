class AddUserReferenceToCourseReviews < ActiveRecord::Migration[5.2]
  add_reference :course_reviews, :user, index: true
end
