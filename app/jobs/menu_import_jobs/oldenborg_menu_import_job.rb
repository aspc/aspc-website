module MenuImportJobs
  class OldenborgMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:oldenborg"
    end
  end
end
