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

ActiveRecord::Schema.define(version: 2018_10_05_144202) do

  create_table "availabilities", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "postcode_id"
    t.float "radius"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_availabilities_on_owner_type_and_owner_id"
    t.index ["postcode_id"], name: "index_availabilities_on_postcode_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name"
    t.integer "postcode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode_id"], name: "index_coaches_on_postcode_id"
  end

  create_table "postcodes", force: :cascade do |t|
    t.string "postcode"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode"], name: "index_postcodes_on_postcode", unique: true
  end

  create_table "referrals", force: :cascade do |t|
    t.integer "coach_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_referrals_on_coach_id"
  end

  create_table "runners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_slots", force: :cascade do |t|
    t.integer "availability_id"
    t.datetime "started_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_time_slots_on_availability_id"
  end

end
