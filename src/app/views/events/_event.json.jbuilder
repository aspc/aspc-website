json.extract! event, :id, :name, :start, :end, :location, :description, :host, :details_url, :status, :created_at, :updated_at
json.url event_url(event, format: :json)
