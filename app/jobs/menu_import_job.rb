class MenuImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Perform each menu import task asynchronously
    MenuImportJobs::FrankMenuImportJob.perform_later
    MenuImportJobs::FraryMenuImportJob.perform_later
    MenuImportJobs::OldenborgMenuImportJob.perform_later
    MenuImportJobs::ClaremontMckennaMenuImportJob.perform_later
    MenuImportJobs::HarveyMuddMenuImportJob.perform_later
    MenuImportJobs::ScrippsMenuImportJob.perform_later
    MenuImportJobs::PitzerMenuImportJob.perform_later
  end
end
