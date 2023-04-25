namespace :review_import do
  desc "Imports Course Reviews"
  task :reviews => :environment do
    Rails.logger.info "Loading old reviews from course_reviews.json"
    reviews_file_path = Rails.root.join('lib', 'tasks', 'course_reviews.json')
    reviews_file = File.read(reviews_file_path)
    reviews = JSON.parse(reviews_file)

    saved = 0
    unsaved = 0

    reviews.each do |review_info|
      course_review = CourseReview.find_or_create_by(
        :overall_rating => review_info['overall_rating'],
        :challenge_rating => review_info['difficulty_rating'],
        :inclusivity_rating => review_info['inclusivity_rating'],
        :total_cost => review_info['total_cost'],
        :work_per_week => review_info['work_per_week'],
        :comments => review_info['comments'],
      )
      course_review.course = Course.find_by(:code_slug => review_info['code_slug'])
      course_review.instructor = Instructor.find_by(:name => review_info['name'])
      course_review.created_at = review_info['created_date']

      if course_review.course and course_review.instructor
        course_review.save!(:validate => false)
        Rails.logger.info "Successfully imported review for #{course_review.course.name}"

        saved += 1
      else
        course_review.destroy
        Rails.logger.info "Could not import course review #{course_review.inspect}"

        unsaved += 1
      end
    end

    Rails.logger.info "Imported #{saved} course reviews. Could not save #{unsaved} course reviews"
  end
end