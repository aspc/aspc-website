module MenuImportJobs
  class HarveyMuddMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:harvey_mudd"
    end
  end
end