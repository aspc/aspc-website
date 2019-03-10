class StaticController < ApplicationController
  require 'rss'
  require 'open-uri'
  require 'nokogiri'

  # NEW - froala

  # Custom form in activeadmin breaks CSRF
  # This is a workaround while we figure out a better solution
  # skip_before_action :verify_authenticity_token, :only => [:upload_image]
  skip_before_action :verify_authenticity_token
  
  # Reference: https://github.com/froala/editor-ruby-sdk-example
  # https://www.froala.com/wysiwyg-editor/docs/sdks/ruby/image-server-upload
  
  # Index.
  def index
  end

  def show
    @page = Static.find_by_id(params[:id])
  end

  # Save content to database
  def save
    @page = Static.find_by_id(params[:id])
    @page[:pending_content] = params[:content]
    @page[:last_modified_by] = current_user[:id]
    @page[:published] = false

    @page.save
  end

  # Approve changes: copy pending_copy to approved_copy
  # def approve
  #   @page = Static.find_by_id(params[:id])
  #   @page[:approved_content] = @page[:pending_content]

  #   @page.save
  # end
  
  # Upload file.
  def upload_file
    render :json => FroalaEditorSDK::File.upload(params, "public/uploads/")
  end
  
  # Delete file.
  def delete_file
    render :json => FroalaEditorSDK::File.delete(params[:src], "public/uploads/")
  end
  
  # Upload image.
  def upload_image
    render :json => FroalaEditorSDK::Image.upload(params, "public/uploads/")
  end
  
  # Load images.
  def load_images
    render :json => FroalaEditorSDK::Image.load_images("public/uploads/")
  end
  
  # Delete image.
  def delete_image
    render :json => FroalaEditorSDK::Image.delete(params[:src], "public/uploads/")
  end

  # OLD - hand-coded static pages
  
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
