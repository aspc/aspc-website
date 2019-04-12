json.extract! housing_review, :id, :new, :create, :show, :index, :quiet_rating, :layout_rating, :temperature_rating, :comments, :created_at, :updated_at
json.url housing_review_url(housing_review, format: :json)
