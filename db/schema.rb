# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130506235621) do

  create_table "dojo_students", :force => true do |t|
    t.integer "dojo_id"
    t.integer "student_id"
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "dojos", :force => true do |t|
    t.string  "name"
    t.string  "street"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.float   "latitude"
    t.float   "longitude"
    t.boolean "active",    :default => true
  end

  create_table "events", :force => true do |t|
    t.string  "name"
    t.boolean "active", :default => true
  end

  create_table "registrations", :force => true do |t|
    t.integer "section_id"
    t.integer "student_id"
    t.date    "date"
    t.boolean "fee_paid"
    t.integer "final_standing"
  end

  create_table "sections", :force => true do |t|
    t.integer "event_id"
    t.integer "min_age"
    t.integer "max_age"
    t.integer "min_rank"
    t.integer "max_rank"
    t.boolean "active",        :default => true
    t.integer "tournament_id"
    t.string  "location"
    t.time    "round_time"
  end

  create_table "students", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.date    "date_of_birth"
    t.integer "rank"
    t.string  "phone"
    t.boolean "waiver_signed", :default => false
    t.boolean "active",        :default => true
  end

  create_table "tournaments", :force => true do |t|
    t.string  "name"
    t.date    "date"
    t.integer "min_rank"
    t.integer "max_rank"
    t.boolean "active",   :default => true
  end

  create_table "users", :force => true do |t|
    t.string  "email"
    t.integer "student_id"
    t.string  "password_digest"
    t.string  "role"
    t.boolean "active",          :default => true
  end

end
