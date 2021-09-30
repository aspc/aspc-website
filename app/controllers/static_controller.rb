class StaticController < ApplicationController
  # Custom form in activeadmin breaks CSRF
  # This is a workaround while we figure out a better solution
  # skip_before_action :verify_authenticity_token, :only => [:upload_image]
  skip_before_action :verify_authenticity_token, :except => [:open_forum]
  before_action :authenticate_user!, :only => [:open_forum]

  # Reference: https://github.com/froala/editor-ruby-sdk-example
  # https://www.froala.com/wysiwyg-editor/docs/sdks/ruby/image-server-upload

  def show
    if params[:id]
      @page = Static.find_by(:id => params[:id])
    elsif params[:page_name]
      @page = Static.find_by(:page_name => params[:page_name])
    end

    if @page.nil?
      raise ActionController::RoutingError, 'Not Found'
    end
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

  # Load an image.s
  def load_image
    if File.exists?(Rails.root.join("public", "uploads", params[:image_name]))
      send_data File.read(Rails.root.join("public", "uploads", "images", params[:name])), :filename => ::File.basename(params[:name]), :disposition => 'inline'
    else
      head :not_found
    end
  end

  # Delete image.
  def delete_image
    render :json => FroalaEditorSDK::Image.delete(params[:src], "public/uploads/")
  end

  ##
  # Custom actions for special, hardcoded views
  def index
    @announcements = Announcement.priority_order.all
    time = Time.parse(Time.now.in_time_zone("Pacific Time (US & Canada)").strftime('%Y-%m-%d %H:%M:%S')).to_s(:db)
    @events = Event.where("start >= ?", time).where(:status => :approved).order(:start).take(9)
    # @news = news
    @news = []
  end

  def senators
    @senators = Person.priority_order.order("id ASC")
  end

  def staff
    @staff = Person.priority_order.staff.order("id ASC")
    @board = Person.priority_order.board.order("id ASC")
  end

  def housing_platform
  end

  def open_forum
    respond_to do |format|
      # Validate parameters
      valid_params = %w[topic question response response_method]
      valid_params.each do |param|
        unless params.has_key? param
          format.js {
            render partial: "components/toast",
                   locals: {
                       message: "Invalid request.",
                       type: "is-danger"
                   }
          }
        end
      end

      # Find an email associated with the provided topic
      begin
        topic_email_mapping = OpenForumMapping.find(params[:topic])
      rescue
        format.js {
          render partial: "components/toast",
                 locals: {
                     message: "Could not find an email for the selected area of concern.",
                     type: "is-danger"
                 }
        }
        return
      end

      # Assign parameters
      question = params[:question]
      should_respond = params[:response]
      response_method = params[:response_method]
      to = topic_email_mapping.email

      # Make sure that the question is not empty and that the response method is not empty in case the user wanted a response
      if not question.blank? and (should_respond == "true" and not response_method.blank? or should_respond == "false")
        OpenForumMailer.with(question: question, should_respond: should_respond, response_method: response_method, to: to).new_open_forum_email.deliver_later
        format.js {
          render partial: "components/toast",
                 locals: {
                     message: "Your message has been sent!",
                     type: "is-success"
                 }
        }
      else
        format.js {
          render partial: "components/toast",
                 locals: {
                     message: "An error occurred while sending your message. Please check your form and try again.",
                     type: "is-danger"
                 }
        }
      end
      format.html
    end
  end

  private

  def news
    require 'rss'
    require 'open-uri'

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
