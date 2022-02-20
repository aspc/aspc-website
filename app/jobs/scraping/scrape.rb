require 'open-uri'

def run_job
    html = open("https://www.pomona.edu/events")
    doc = Nokogiri::HTML(html)
end

