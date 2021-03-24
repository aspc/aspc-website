class CourseImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    system "rake course_import:academic_terms"
    system "rake course_import:departments"
    system "rake course_import:courses"
  end
end
