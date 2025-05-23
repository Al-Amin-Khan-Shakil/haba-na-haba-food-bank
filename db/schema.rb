# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_12_131924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "branches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "counties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "district_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_counties_on_district_id"
  end

  create_table "districts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "branch_id"
    t.index ["branch_id"], name: "index_districts_on_branch_id"
  end

  create_table "donations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "donor_name"
    t.string "phone_number"
    t.integer "donation_type"
    t.string "donation_name"
    t.integer "amount"
    t.integer "donor_type"
    t.uuid "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_donations_on_request_id"
  end

  create_table "event_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_users_on_event_id"
    t.index ["user_id"], name: "index_event_users_on_user_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.uuid "district_id", null: false
    t.uuid "county_id", null: false
    t.uuid "sub_county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_events_on_county_id"
    t.index ["district_id"], name: "index_events_on_district_id"
    t.index ["sub_county_id"], name: "index_events_on_sub_county_id"
  end

  create_table "family_beneficiaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "family_members"
    t.integer "male"
    t.integer "female"
    t.integer "children"
    t.text "adult_age_range"
    t.text "children_age_range"
    t.uuid "district_id", null: false
    t.uuid "county_id", null: false
    t.uuid "sub_county_id", null: false
    t.text "address_note"
    t.text "village"
    t.text "parish"
    t.text "phone_number"
    t.text "case_name"
    t.text "case_description"
    t.text "fathers_name"
    t.text "mothers_name"
    t.text "fathers_occupation"
    t.text "mothers_occupation"
    t.integer "number_of_meals_home"
    t.integer "number_of_meals_school"
    t.text "basic_FEH"
    t.text "basic_FES"
    t.decimal "provided_food"
    t.uuid "request_id"
    t.uuid "event_id"
    t.uuid "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_family_beneficiaries_on_branch_id"
    t.index ["county_id"], name: "index_family_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_family_beneficiaries_on_district_id"
    t.index ["event_id"], name: "index_family_beneficiaries_on_event_id"
    t.index ["request_id"], name: "index_family_beneficiaries_on_request_id"
    t.index ["sub_county_id"], name: "index_family_beneficiaries_on_sub_county_id"
  end

  create_table "individual_beneficiaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "gender"
    t.string "phone_number"
    t.string "case_name"
    t.string "case_description"
    t.string "father_name"
    t.string "mother_name"
    t.string "sur_name"
    t.decimal "provided_food"
    t.string "village"
    t.string "parish"
    t.string "address_note"
    t.uuid "district_id", null: false
    t.uuid "county_id", null: false
    t.uuid "sub_county_id", null: false
    t.uuid "request_id"
    t.uuid "branch_id"
    t.uuid "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_individual_beneficiaries_on_branch_id"
    t.index ["county_id"], name: "index_individual_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_individual_beneficiaries_on_district_id"
    t.index ["event_id"], name: "index_individual_beneficiaries_on_event_id"
    t.index ["request_id"], name: "index_individual_beneficiaries_on_request_id"
    t.index ["sub_county_id"], name: "index_individual_beneficiaries_on_sub_county_id"
  end

  create_table "inventories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "expire_date"
    t.decimal "amount"
    t.decimal "cost_of_item"
    t.string "collection_place"
    t.string "phone_number"
    t.string "donor_name"
    t.uuid "district_id", null: false
    t.uuid "county_id", null: false
    t.uuid "sub_county_id", null: false
    t.uuid "request_id"
    t.uuid "branch_id"
    t.uuid "event_id"
    t.uuid "donation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_inventories_on_branch_id"
    t.index ["county_id"], name: "index_inventories_on_county_id"
    t.index ["district_id"], name: "index_inventories_on_district_id"
    t.index ["donation_id"], name: "index_inventories_on_donation_id"
    t.index ["event_id"], name: "index_inventories_on_event_id"
    t.index ["request_id"], name: "index_inventories_on_request_id"
    t.index ["sub_county_id"], name: "index_inventories_on_sub_county_id"
  end

  create_table "organization_beneficiaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "organization_name"
    t.integer "male"
    t.integer "female"
    t.text "adult_age_range"
    t.text "children_age_range"
    t.uuid "district_id", null: false
    t.uuid "county_id", null: false
    t.uuid "sub_county_id", null: false
    t.text "address_note"
    t.text "village"
    t.text "parish"
    t.text "phone_number"
    t.text "case_name"
    t.text "case_description"
    t.text "registration_no"
    t.text "organization_no"
    t.text "directors_name"
    t.text "head_of_institution"
    t.integer "number_of_meals_home"
    t.text "basic_FEH"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "provided_food"
    t.integer "event_id"
    t.uuid "branch_id"
    t.uuid "request_id"
    t.index ["county_id"], name: "index_organization_beneficiaries_on_county_id"
    t.index ["district_id"], name: "index_organization_beneficiaries_on_district_id"
    t.index ["id"], name: "index_organization_beneficiaries_on_id", unique: true
    t.index ["sub_county_id"], name: "index_organization_beneficiaries_on_sub_county_id"
  end

  create_table "requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.integer "request_type"
    t.boolean "is_selected"
    t.string "village"
    t.string "parish"
    t.string "address_note"
    t.uuid "branch_id", null: false
    t.uuid "district_id", null: false
    t.uuid "county_id"
    t.uuid "sub_county_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_requests_on_branch_id"
    t.index ["county_id"], name: "index_requests_on_county_id"
    t.index ["district_id"], name: "index_requests_on_district_id"
    t.index ["sub_county_id"], name: "index_requests_on_sub_county_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "sub_counties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_sub_counties_on_county_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "role"
    t.string "gender"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "counties", "districts"
  add_foreign_key "districts", "branches"
  add_foreign_key "donations", "requests"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "events", "counties"
  add_foreign_key "events", "districts"
  add_foreign_key "events", "sub_counties"
  add_foreign_key "family_beneficiaries", "branches"
  add_foreign_key "family_beneficiaries", "counties"
  add_foreign_key "family_beneficiaries", "districts"
  add_foreign_key "family_beneficiaries", "events"
  add_foreign_key "family_beneficiaries", "requests"
  add_foreign_key "family_beneficiaries", "sub_counties"
  add_foreign_key "individual_beneficiaries", "branches"
  add_foreign_key "individual_beneficiaries", "counties"
  add_foreign_key "individual_beneficiaries", "districts"
  add_foreign_key "individual_beneficiaries", "events"
  add_foreign_key "individual_beneficiaries", "requests"
  add_foreign_key "individual_beneficiaries", "sub_counties"
  add_foreign_key "inventories", "branches"
  add_foreign_key "inventories", "counties"
  add_foreign_key "inventories", "districts"
  add_foreign_key "inventories", "donations"
  add_foreign_key "inventories", "events"
  add_foreign_key "inventories", "requests"
  add_foreign_key "inventories", "sub_counties"
  add_foreign_key "organization_beneficiaries", "counties"
  add_foreign_key "organization_beneficiaries", "districts"
  add_foreign_key "organization_beneficiaries", "sub_counties"
  add_foreign_key "requests", "branches"
  add_foreign_key "requests", "counties"
  add_foreign_key "requests", "districts"
  add_foreign_key "requests", "sub_counties"
  add_foreign_key "requests", "users"
  add_foreign_key "sub_counties", "counties"
end
