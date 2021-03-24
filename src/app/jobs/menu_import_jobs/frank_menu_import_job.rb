module MenuImportJobs
  class FrankMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:frank"
    end
  end
end