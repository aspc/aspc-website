module MenuImportJobs
  class ScrippsMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:scripps"
    end
  end
end
