class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    # Only display approved events
    @events = Event.where(:status => :approved)
    
    # Pull Engage events from API and save to database
    EngageEventsService.new().get_events()
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @user = current_user
  end

  # GET /events/1/edit
  def edit
    @user = current_user
  end

  # POST /events
  # POST /events.json
  def create
    error_parsing_time = false

    start_date = event_params[:start_date]
    start_hour = event_params[:start_hour]
    start_minute = event_params[:start_minute]
    start_meridiem = event_params[:start_meridiem]
    start_time = DateTime.strptime("#{start_date} #{start_hour}:#{start_minute} #{start_meridiem}",
                                   '%Y-%m-%d %H:%M %p') rescue error_parsing_time = true

    end_date = event_params[:end_date]
    end_hour = event_params[:end_hour]
    end_minute = event_params[:end_minute]
    end_meridiem = event_params[:end_meridiem]
    end_time = DateTime.strptime("#{end_date} #{end_hour}:#{end_minute} #{end_meridiem}", '%Y-%m-%d
                                 %H:%M %p') rescue error_parsing_time = true

    @event = Event.new(
        :name => event_params[:name],
        :location => event_params[:location],
        :description => event_params[:description],
        :host => event_params[:host],
        :details_url => event_params[:details_url],
        :submitted_by_user_fk => event_params[:submitted_by_user_fk],
    )

    unless error_parsing_time
      @event.start = start_time
      @event.end = end_time
    end

    respond_to do |format|
      if @event.save
        # Send notification email using EventsMailer
        EventsMailer.event_notification_email(@event).deliver_later

        format.html { redirect_to @event, notice: 'Event was successfully asdf submitted.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    event = Event.find_by_id(params[:id])

    if !event
      return redirect_to events_path, :flash => {
          :notice => "Cannot export event",
          :notice_subtitle => "Invalid event selected!",
          :notice_class => "is-danger",
      }
    end

    calendar = Icalendar::Calendar.new
    calendar.version = "2.0"
    filename = "#{event.name.parameterize}.ics"

    calendar_event = calendar.event
    calendar_event.summary = event.name
    calendar_event.dtstart = Icalendar::Values::DateTime.new(event.start)
    calendar_event.dtend = Icalendar::Values::DateTime.new(event.end)
    calendar_event.description = event.description
    calendar_event.location = event.location

    send_data calendar.to_ical, type: "text/calendar", disposition: "attachment", filename: filename
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params
          .require(:event)
          .permit(:name, :location, :description, :host, :details_url, :status,
                  :submitted_by_user_fk,
                  :end_date, :end_hour, :end_minute, :end_meridiem, :start_date, :start_hour,
                  :start_minute, :start_meridiem)
    end

    def new_calendar_event(calendar, date, course_section, detail)
      event = calendar.event
      event.summary = "#{course_section.course.code} #{course_section.course.name}"
      start_time = DateTime.new(date.year, date.month, date.day, detail.start_time.hour,
                                detail.start_time.min, 0)
      end_time = DateTime.new(date.year, date.month, date.day, detail.end_time.hour,
                              detail.end_time.min, 0)
      event.dtstart = Icalendar::Values::DateTime.new(start_time)
      event.dtend = Icalendar::Values::DateTime.new(end_time)
      event.description = course_section.description
      event.location = detail.location
    end

    # Map a database collection of Events to something our
    # calendar javascript library (fullcalendar.js) understands
    def _to_event_calendar_mapping(events)
      events.map do |event|
        {
          :title => event.name,
          :start => event.start,
          :end => event.end,
          :url => event_url(event, format: :html),
          :host => event.host
        }
      end
    end
    helper_method :_to_event_calendar_mapping
end
