module MenuImportJobs
  class ClaremontMckennaMenuImportJob < ApplicationJob
    queue_as :default

    def perform(*args)
      system "rake menu_import:claremont_mckenna"
    end
  end
end