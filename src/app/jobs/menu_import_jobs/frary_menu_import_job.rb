module MenuImportJobs
  class FraryMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:frary"
    end
  end
end