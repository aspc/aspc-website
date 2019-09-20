# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_12_005931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_terms", force: :cascade do |t|
    t.string "key"
    t.string "session"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.text "title", null: false
    t.text "caption"
    t.string "details_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
  end

  create_table "course_meeting_details", force: :cascade do |t|
    t.time "start_time"
    t.time "end_time"
    t.boolean "monday", default: false, null: false
    t.boolean "tuesday", default: false, null: false
    t.boolean "wednesday", default: false, null: false
    t.boolean "thursday", default: false, null: false
    t.boolean "friday", default: false, null: false
    t.integer "campus", default: 0, null: false
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_section_id"
    t.index ["course_section_id"], name: "index_course_meeting_details_on_course_section_id"
  end

  create_table "course_reviews", force: :cascade do |t|
    t.decimal "overall_rating"
    t.decimal "challenge_rating"
    t.decimal "inclusivity_rating"
    t.decimal "work_per_week"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.bigint "instructor_id"
    t.bigint "user_id"
    t.index ["course_id"], name: "index_course_reviews_on_course_id"
    t.index ["instructor_id"], name: "index_course_reviews_on_instructor_id"
    t.index ["user_id"], name: "index_course_reviews_on_user_id"
  end

  create_table "course_schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_course_schedules_on_user_id"
  end

  create_table "course_schedules_sections", id: false, force: :cascade do |t|
    t.bigint "course_schedule_id", null: false
    t.bigint "course_section_id", null: false
    t.index ["course_schedule_id"], name: "index_course_schedules_sections_on_course_schedule_id"
    t.index ["course_section_id"], name: "index_course_schedules_sections_on_course_section_id"
  end

  create_table "course_sections", force: :cascade do |t|
    t.string "code", null: false
    t.string "code_slug", null: false
    t.text "description"
    t.decimal "credit", default: "1.0", null: false
    t.integer "perms"
    t.integer "spots"
    t.boolean "filled"
    t.boolean "fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.bigint "academic_term_id"
    t.index ["academic_term_id"], name: "index_course_sections_on_academic_term_id"
    t.index ["course_id"], name: "index_course_sections_on_course_id"
  end

  create_table "course_sections_instructors", id: false, force: :cascade do |t|
    t.bigint "course_section_id", null: false
    t.bigint "instructor_id", null: false
    t.index ["course_section_id"], name: "index_course_sections_instructors_on_course_section_id"
    t.index ["instructor_id"], name: "index_course_sections_instructors_on_instructor_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "code", null: false
    t.string "code_slug", null: false
    t.integer "number", default: 0, null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_courses_on_code", unique: true
    t.index ["code_slug"], name: "index_courses_on_code_slug", unique: true
  end

  create_table "courses_departments", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "department_id", null: false
    t.index ["course_id"], name: "index_courses_departments_on_course_id"
    t.index ["department_id"], name: "index_courses_departments_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_departments_on_code", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "start", null: false
    t.datetime "end", null: false
    t.text "location", null: false
    t.text "description", null: false
    t.text "host"
    t.text "details_url"
    t.integer "status", default: 0, null: false
    t.integer "submitted_by_user_fk", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "college_affiliation", default: 0, null: false
    t.index ["college_affiliation"], name: "index_events_on_college_affiliation"
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "housing_buildings", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.integer "floors", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_housing_buildings_on_name", unique: true
  end

  create_table "housing_reviews", force: :cascade do |t|
    t.decimal "overall_rating", default: "0.0", null: false
    t.decimal "quiet_rating", default: "0.0", null: false
    t.decimal "layout_rating", default: "0.0", null: false
    t.decimal "temperature_rating", default: "0.0", null: false
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "housing_room_id"
    t.bigint "user_id"
    t.index ["housing_room_id"], name: "index_housing_reviews_on_housing_room_id"
    t.index ["user_id"], name: "index_housing_reviews_on_user_id"
  end

  create_table "housing_rooms", force: :cascade do |t|
    t.decimal "size", default: "0.0", null: false
    t.integer "occupancy_type", default: 0, null: false
    t.integer "closet_type", default: 0, null: false
    t.integer "bathroom_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "housing_suite_id"
    t.bigint "housing_building_id"
    t.string "room_number", null: false
    t.index ["housing_building_id"], name: "index_housing_rooms_on_housing_building_id"
    t.index ["housing_suite_id"], name: "index_housing_rooms_on_housing_suite_id"
  end

  create_table "housing_suites", force: :cascade do |t|
    t.integer "suite_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "housing_building_id"
    t.index ["housing_building_id"], name: "index_housing_suites_on_housing_building_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "inclusivity_rating"
    t.decimal "competency_rating"
    t.decimal "challenge_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.text "name", null: false
    t.string "station"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "menu_id"
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
    t.index ["name"], name: "index_menu_items_on_name"
    t.index ["station"], name: "index_menu_items_on_station"
  end

  create_table "menus", force: :cascade do |t|
    t.integer "dining_hall", null: false
    t.integer "meal_type", null: false
    t.integer "day", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hours"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.integer "role", default: 0
    t.string "email"
    t.text "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "statics", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "pending_content"
    t.text "approved_content"
    t.integer "last_modified_by"
    t.boolean "published", default: false
    t.string "page_name"
    t.index ["page_name"], name: "index_statics_on_page_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.boolean "is_cas_authenticated", null: false
    t.integer "school", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

end
