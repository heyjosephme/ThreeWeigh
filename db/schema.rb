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

ActiveRecord::Schema[8.0].define(version: 2025_09_22_145624) do
  create_table "fasting_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "planned_duration"
    t.string "status", default: "active"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_fasting_entries_on_status"
    t.index ["user_id", "start_time"], name: "index_fasting_entries_on_user_id_and_start_time"
    t.index ["user_id"], name: "index_fasting_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "height", precision: 5, scale: 1
    t.integer "age"
    t.string "gender"
    t.decimal "goal_weight", precision: 5, scale: 1
    t.string "unit_system", default: "metric", null: false
    t.string "activity_level"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weight_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.decimal "weight"
    t.date "date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_weight_entries_on_user_id"
  end

  add_foreign_key "fasting_entries", "users"
  add_foreign_key "weight_entries", "users"
end
