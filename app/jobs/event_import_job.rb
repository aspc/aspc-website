class EventImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    system "rake event_import:facebook"
  end
end
