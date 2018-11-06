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

ActiveRecord::Schema.define(version: 2018_11_06_111237) do

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

  create_table "coordinators", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_recipients", force: :cascade do |t|
    t.bigint "email_id"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_email_recipients_on_email_id"
    t.index ["recipient_type", "recipient_id"], name: "index_email_recipients_on_recipient_type_and_recipient_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "sender_type"
    t.bigint "sender_id"
    t.string "object_type"
    t.bigint "object_id"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_type", "object_id"], name: "index_emails_on_object_type_and_object_id"
    t.index ["sender_type", "sender_id"], name: "index_emails_on_sender_type_and_sender_id"
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

  create_table "referral_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.json "metadata", default: {}
    t.integer "sort_key", null: false
    t.integer "referral_id", null: false
    t.boolean "most_recent", null: false
    t.string "transitioner_type"
    t.bigint "transitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referral_id", "most_recent"], name: "index_referral_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["referral_id", "sort_key"], name: "index_referral_transitions_parent_sort", unique: true
    t.index ["transitioner_type", "transitioner_id"], name: "index_referral_transitions_transitioner"
  end

  create_table "referrals", force: :cascade do |t|
    t.jsonb "preferences", default: "{}", null: false
    t.bigint "coach_id"
    t.bigint "referrer_id"
    t.bigint "postcode_id"
    t.integer "volunteers_needed", null: false
    t.integer "duration", null: false
    t.datetime "confirmation_by"
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
  add_foreign_key "email_recipients", "emails"
  add_foreign_key "referral_transitions", "referrals"
  add_foreign_key "referrals", "coaches"
  add_foreign_key "referrals", "postcodes"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "reservation_time_slots", "reservations"
  add_foreign_key "reservation_time_slots", "time_slots"
  add_foreign_key "reservations", "referrals"
  add_foreign_key "reservations", "runners"
  add_foreign_key "runners", "postcodes"
end
