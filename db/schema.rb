# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_08_154003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "encrypted_bank_name"
    t.string "encrypted_bank_name_iv"
    t.string "encrypted_bic"
    t.string "encrypted_bic_iv"
    t.string "encrypted_iban"
    t.string "encrypted_iban_iv"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bank_accounts_on_user_id", unique: true
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "legal_name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "legal_agent"
    t.bigint "wind_farm_id"
    t.string "slug"
    t.index ["slug"], name: "index_companies_on_slug", unique: true
    t.index ["wind_farm_id"], name: "index_companies_on_wind_farm_id"
  end

  create_table "daily_data", id: :serial, force: :cascade do |t|
    t.date "day", null: false
    t.integer "wind_turbine_id"
    t.float "production", null: false
    t.float "consumption", null: false
    t.float "disponibility", null: false
    t.float "wind_speed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wind_turbine_id"], name: "index_daily_data_on_wind_turbine_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "loans", force: :cascade do |t|
    t.string "name", null: false
    t.float "amount", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_loans_on_company_id"
    t.index ["name"], name: "index_loans_on_name", unique: true
  end

  create_table "productibles", id: :serial, force: :cascade do |t|
    t.integer "month"
    t.string "name"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shares", force: :cascade do |t|
    t.string "name", null: false
    t.float "amount", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_shares_on_company_id"
    t.index ["name"], name: "index_shares_on_name", unique: true
  end

  create_table "user_loans", force: :cascade do |t|
    t.date "date", null: false
    t.integer "quantity", null: false
    t.bigint "loan_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["loan_id"], name: "index_user_loans_on_loan_id"
    t.index ["user_id"], name: "index_user_loans_on_user_id"
  end

  create_table "user_shares", force: :cascade do |t|
    t.date "date", null: false
    t.integer "quantity", null: false
    t.bigint "share_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["share_id"], name: "index_user_shares_on_share_id"
    t.index ["user_id"], name: "index_user_shares_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "address"
    t.string "zip_code", limit: 5
    t.string "city"
    t.string "phone", limit: 25
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "shareholder_number"
    t.string "authentication_token", limit: 30
    t.string "role"
    t.string "civility"
    t.string "maiden_name"
    t.date "birth_date"
    t.string "birth_country"
    t.string "birth_department"
    t.string "birth_city_code"
    t.string "birth_city"
    t.string "additional_address"
    t.string "city_code"
    t.integer "start_up_actions"
    t.integer "first_round_actions"
    t.integer "first_round_obligations"
    t.integer "second_round_actions"
    t.integer "second_round_obligations"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "wind_farms", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reference"
    t.index ["name"], name: "index_wind_farms_on_name", unique: true
    t.index ["slug"], name: "index_wind_farms_on_slug", unique: true
  end

  create_table "wind_turbines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "wind_farm_id"
    t.string "wea_name"
    t.boolean "enabled", default: true, null: false
    t.index ["wind_farm_id"], name: "index_wind_turbines_on_wind_farm_id"
  end

  add_foreign_key "bank_accounts", "users"
  add_foreign_key "companies", "wind_farms"
  add_foreign_key "daily_data", "wind_turbines"
  add_foreign_key "loans", "companies"
  add_foreign_key "shares", "companies"
  add_foreign_key "user_loans", "loans"
  add_foreign_key "user_loans", "users"
  add_foreign_key "user_shares", "shares"
  add_foreign_key "user_shares", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "wind_turbines", "wind_farms"
end
