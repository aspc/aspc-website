Rails.application.routes.draw do
  root :to => 'static#index'

  ActiveAdmin.routes(self)

  resources :events do
    member do
      get :export
    end
  end

  scope controller: :housing_rooms do
    get 'housing' => :show_buildings, :as => :housing_rooms
    get 'housing/dorms/:dorm_id' => :show_building_rooms, :as => :show_housing_rooms_for_dorm
    get 'housing/dorms/:dorm_id/floor_plans' => :floor_plans, :as => :floor_plans
    get 'housing/rooms/:room_id' => :show, :as => :show_housing_room
  end

  scope controller: :housing_reviews do
    get 'housing/rooms/:room_id/reviews/' => :index, :as => :housing_reviews
    post 'housing/rooms/:room_id/reviews/' => :create, :as => :create_housing_review
    get 'housing/rooms/:room_id/reviews/new' => :new, :as => :new_housing_review
    get 'housing/rooms/:room_id/reviews/:id' => :show, :as => :housing_review
    delete 'housing/rooms/:room_id/reviews/:id' => :destroy, :as => :delete_housing_review
  end

  scope controller: :course_reviews do
    get 'reviews/courses' => :show_course_reviews, as: :course_reviews
    get 'reviews/instructors' => :show_instructor_reviews, as: :instructor_reviews
    get 'reviews/courses/:course_id/new' => :new, as: :new_course_review
    post 'reviews/courses/search' => :search_course_reviews, as: :course_reviews_search
    post 'reviews/instructors/search' => :search_instructor_reviews, as: :instructor_reviews_search
    post 'reviews/courses' => :create, as: :create_course_review
    delete 'reviews/:id' => :destroy, :as => :delete_course_review
  end

  scope controller: :courses do
    get 'courses/planner' => :index, as: :course_planner
    get 'courses/planner/export' => :export_course_sections, as: :courses_export
    post 'courses/planner/add' => :add_course_section_to_schedule, as: :courses_add
    post 'courses/planner/remove' => :remove_course_section_from_schedule, as: :courses_remove
    post 'courses/planner/clear' => :clear_course_sections_from_schedule, as: :courses_clear
    post 'courses/planner/save' => :save_course_sections_to_schedule, as: :courses_save

    match 'courses/search' => :search_course_sections, :via => [:get, :post]

    get 'courses/:id/review' => :add_review_course_section, as: :review_course_section
    get 'courses/:id' => :show, as: :course
  end

  scope controller: :instructors do
    get 'instructors' => :index
    get 'instructors/:id/review' => :add_instructor_review, as: :review_instructor
    get 'instructors/:id' => :show, as: :instructor
    match 'instructors/search' => :search, :via => [:get, :post]
  end

  scope controller: :menu do
    get 'menus' => :index
    match 'menus/:dining_hall' => :show, :via => [:get, :post]
    match 'menus/:meal_type' => :show, :via => [:get, :post]
  end

  scope controller: :sessions do
    get 'unauthorized' => :not_authorized
    match 'logout' => :destroy, :via => [:get, :destroy]
    get 'login' => :new
    match 'login/cas' => :create_via_cas, :via => [:get, :post]
    match 'login/credentials' => :create_via_credentials, :via => [:get, :post]
    match 'login/create_account' => :create_new_account, :via => [:get, :post]
  end

  scope controller: :static do
    # Hardcoded pages not created via the CMS
    get 'index' => :index
    get 'senators' => :senators
    get 'staff' => :staff
    get 'sdg' => :sdg
    get 'housing-platform' => :housing_platform
    get 'career-opportunities' => :career_opportunities
    get 'seniorclass' => :senior_class
    
    match 'contact-aspc' => :open_forum, :via => [:get, :post]

    # Editable pages created via the CMS
    get 'pages/id/:id' => :show, as: :static_page
    get 'pages/:page_name' => :show, as: :static

    post 'pages/:id/update' => 'static#save', as: :static_page_update
    post 'pages/:id/upload_image' => 'static#upload_image', as: :static_page_upload_image
    post 'pages/:id/delete_image' => 'static#delete_image', as: :static_page_delete_image
    post 'pages/:id/upload_file' => 'static#upload_file', as: :static_page_upload_file
    post 'pages/:id/delete_file' => 'static#delete_file', as: :static_page_delete_file

    get '/uploads/:image_name' => :load_image
  end
end
