Rails.application.routes.draw do
  root :to => 'static#index'

  ActiveAdmin.routes(self)

  resources :events

  scope controller: :courses do
    get 'courses' => :index
    post 'courses/add' => :add_course_section_to_schedule
    post 'courses/remove' => :remove_course_section_from_schedule
    post 'courses/clear' => :clear_course_sections_from_schedule
    post 'courses/save' => :save_course_sections_to_schedule
    match 'courses/search' => :search_course_sections, :via => [:get, :post]
  end

  scope controller: :sessions do
    get   'login' => :new
    match 'logout' => :destroy, :via => [:get, :destroy]
    match 'sessions/create' => :create, :via => [:get, :post]
  end

  scope controller: :static do
    get 'index' => :index

    get 'aspc/senators' => :aspc_senators
    get 'aspc/staff' => :aspc_staff
    get 'aspc/committee' => :aspc_committee
    get 'aspc/software' => :aspc_software

    get 'aspc/positions' => :aspc_positions
    get 'aspc/policies' => :aspc_policies
    get 'aspc/budget' => :aspc_budget
    get 'aspc/minutes' => :aspc_meeting_minutes

    get 'resources/pec' => :resources_pec
    get 'resources/clubs' => :resources_clubs
    get 'resources/campus-eateries' => :resources_on_campus_eateries
    get 'resources/api' => :resources_api
  end
end
