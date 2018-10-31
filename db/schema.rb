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

ActiveRecord::Schema.define(version: 2018_10_30_112730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.bigint "runner_id"
    t.string "location"
    t.boolean "enabled", null: false
    t.float "radius"
    t.bigint "postcode_id"
    t.jsonb "weekly_schedule", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode_id"], name: "index_alerts_on_postcode_id"
    t.index ["runner_id"], name: "index_alerts_on_runner_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "runner_id"
    t.bigint "postcode_id"
    t.float "radius"
    t.jsonb "preferences", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode_id"], name: "index_availabilities_on_postcode_id"
    t.index ["runner_id"], name: "index_availabilities_on_runner_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "postcodes", force: :cascade do |t|
    t.string "postcode"
    t.float "lat"
    t.float "lng"
    t.jsonb "geodata", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode"], name: "index_postcodes_on_postcode", unique: true
  end

  create_table "referrals", force: :cascade do |t|
    t.bigint "coach_id"
    t.bigint "referrer_id"
    t.bigint "postcode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_referrals_on_coach_id"
    t.index ["postcode_id"], name: "index_referrals_on_postcode_id"
    t.index ["referrer_id"], name: "index_referrals_on_referrer_id"
  end

  create_table "referrers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservation_time_slots", force: :cascade do |t|
    t.bigint "reservation_id"
    t.bigint "time_slot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reservation_time_slots_on_reservation_id"
    t.index ["time_slot_id"], name: "index_reservation_time_slots_on_time_slot_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "runner_id"
    t.bigint "referral_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referral_id"], name: "index_reservations_on_referral_id"
    t.index ["runner_id"], name: "index_reservations_on_runner_id"
  end

  create_table "runners", force: :cascade do |t|
    t.string "name"
    t.bigint "postcode_id"
    t.float "default_radius"
    t.jsonb "preferences", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode_id"], name: "index_runners_on_postcode_id"
  end

  create_table "time_slots", force: :cascade do |t|
    t.string "booking_type"
    t.bigint "booking_id"
    t.datetime "started_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_type", "booking_id"], name: "index_time_slots_on_booking_type_and_booking_id"
  end

  add_foreign_key "alerts", "postcodes"
  add_foreign_key "alerts", "runners"
  add_foreign_key "availabilities", "postcodes"
  add_foreign_key "availabilities", "runners"
  add_foreign_key "referrals", "coaches"
  add_foreign_key "referrals", "postcodes"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "reservation_time_slots", "reservations"
  add_foreign_key "reservation_time_slots", "time_slots"
  add_foreign_key "reservations", "referrals"
  add_foreign_key "reservations", "runners"
  add_foreign_key "runners", "postcodes"
end
