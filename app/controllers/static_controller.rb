class StaticController < ApplicationController
  require 'rss'
  require 'open-uri'
  require 'nokogiri'

  def index
    @announcements = Announcement.all
    time = Time.parse(Time.now.in_time_zone("Pacific Time (US & Canada)").strftime('%Y-%m-%d %H:%M:%S')).to_s(:db)
    @events = Event.where("start >= ?", time).where(:status => :approved).order(:start).take(3)
    @news = news
  end

  def aspc_senators
    @senators = Person.senator.order("id ASC")
  end

  def aspc_staff
    @staff = Person.staff.order("id ASC")
    @board = Person.board.order("id ASC")
  end

  private

  def news
    rss_results = []
    rss = RSS::Parser.parse(open("https://tsl.news/feed").read, false).items[0..2]

    rss.each do |result|
      html = Nokogiri::HTML(result.description)
      description = html.xpath("//p")[0].to_s + "..."
      result = {title: result.title, date: result.pubDate, link: result.link, description: description}
      rss_results.push(result)
    end
    return rss_results
  end

end