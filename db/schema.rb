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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150702094607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "schedules", force: :cascade do |t|
    t.string   "state",                   comment: "2 Character State Code or FEDERAL"
    t.date     "start_date",              comment: "Date the schedule became The Law"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "substance_schedules", force: :cascade do |t|
    t.integer  "substance_id"
    t.integer  "schedule_id"
    t.integer  "schedule_level",              comment: "1, 2, 3, 4, or 5"
    t.string   "penalty"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "substances", force: :cascade do |t|
    t.string   "name"
    t.string   "classification",                              comment: "e.g. opioid, stimulant, depressant"
    t.string   "chemical_formula",                            comment: "In a readable format, e.g. N-ethyl-3-piperidyl benzilat"
    t.string   "chemical_formula_smiles_format",              comment: "Follows the SMILE standard: https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end