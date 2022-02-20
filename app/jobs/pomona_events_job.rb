
class PomonaEventsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    html = open("https://www.pomona.edu/events")
    doc = Nokogiri::HTML(html)
    doc.css("tr.twSimpleTableEventRow0").each |item| do
      put item 
    end

  end
  
end
