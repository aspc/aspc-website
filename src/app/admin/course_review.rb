course_review_page = Proc.new do
  menu parent: "Models"

  permit_params :overall_rating, :challenge_rating, :inclusivity_rating, :comments, :course_id, :work_per_week
end

ActiveAdmin.register CourseReview, :namespace => :admin, &course_review_page