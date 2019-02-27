Rails.application.routes.draw do
  root :to => 'static#index'

  ActiveAdmin.routes(self)

  resources :events

  scope controller: :course_reviews do
    get 'courses/:course_id/review/new' => :new, as: :new_course_review
    post 'reviews' => :create, as: :course_reviews
  end

  scope controller: :courses do
    get 'courses' => :index
    get 'courses/export' => :export_course_sections
    get 'courses/:id' => :show, as: :course
    post 'courses/add' => :add_course_section_to_schedule
    post 'courses/remove' => :remove_course_section_from_schedule
    post 'courses/clear' => :clear_course_sections_from_schedule
    post 'courses/save' => :save_course_sections_to_schedule
    match 'courses/search' => :search_course_sections, :via => [:get, :post]
  end

  scope controller: :instructors do
    get 'instructors/:id' => :show, as: :instructor
  end

  scope controller: :menu do
    get 'menus' => :index
    match 'menus/:dining_hall' => :show, :via => [:get, :post]
    match 'menus/:meal_type' => :show, :via => [:get, :post]
  end

  scope controller: :sessions do
    get   'unauthorized' => :not_authorized
    match 'logout' => :destroy, :via => [:get, :destroy]
    get 'login' => :new
    match 'login/cas' => :create_via_cas, :via => [:get, :post]
    match 'login/credentials' => :create_via_credentials, :via => [:get, :post]
    match 'login/create_account' => :create_new_account, :via => [:get, :post]
  end

  scope controller: :static do
    get 'index' => :index

    get 'aspc/senators' => :aspc_senators
    get 'aspc/staff' => :aspc_staff
    get 'aspc/committee' => :aspc_committee
    get 'aspc/pec' => :aspc_pec
    get 'aspc/software' => :aspc_software
    get 'aspc/positions' => :aspc_positions
    get 'aspc/policies' => :aspc_policies
    get 'aspc/policies/constitution' => :aspc_policies_constitution
    get 'aspc/policies/bylaws' => :aspc_policies_bylaws
    get 'aspc/policies/positions' => :aspc_positions
    get 'aspc/policies/electionscode' => :aspc_policies_electionscode
    get 'aspc/budget' => :aspc_budget
    get 'aspc/meeting-minutes' => :aspc_meeting_minutes
    get 'aspc/funding-request' => :aspc_funding_request

    get 'resources/api' => :resources_api
    get 'resources/coop-fountain' => :resources_coop_fountain

    get 'courses/reviews' => :reviews_coming_soon
  end
end
