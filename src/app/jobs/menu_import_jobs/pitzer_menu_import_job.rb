module MenuImportJobs
  class PitzerMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:pitzer"
    end
  end
end